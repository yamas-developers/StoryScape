import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/custom_effect.dart';
import 'package:provider/provider.dart';
import 'package:stories_app/providers/app_provider.dart';

import 'widgets/open_story.dart';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({
    Key? key,
    this.imageSize,
  }) : super(key: key);
  final Size? imageSize;

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  static const int _gridSize = 3;

  // Index starts in the middle of the grid (eg, 25 items, index will start at 13)
  int _index = ((_gridSize * _gridSize) / 2).round();
  Offset _lastSwipeDir = Offset.zero;
  final double _scale = 1;
  bool _skipNextOffsetTween = false;
  late Duration swipeDuration = const Duration(milliseconds: 600) * .4;

  // final _photoIds = ValueNotifier<List<String>>([]);

  int get _imgCount => pow(_gridSize, 2).round();

  late final List<FocusNode> _focusNodes =
      List.generate(_imgCount, (index) => FocusNode());

  //TODO: Remove this field (and associated workarounds) once web properly supports ClipPath (https://github.com/flutter/flutter/issues/124675)
  final bool useClipPathWorkAroundForWeb = kIsWeb;

  @override
  void initState() {
    super.initState();
    // _initPhotoIds();
    _focusNodes[_index].requestFocus();
  }

  void _setIndex(int value, {bool skipAnimation = false}) {
    if (value < 0 || value >= _imgCount) return;
    _skipNextOffsetTween = skipAnimation;
    setState(() => _index = value);
    _focusNodes[value].requestFocus();
  }

  /// Determine the required offset to show the current selected index.
  /// index=0 is top-left, and the index=max is bottom-right.
  Offset _calculateCurrentOffset(double padding, Size size) {
    double halfCount = (_gridSize / 2).floorToDouble();
    Size paddedImageSize = Size(size.width + padding, size.height + padding);
    // Get the starting offset that would show the top-left image (index 0)
    final originOffset = Offset(
        halfCount * paddedImageSize.width, halfCount * paddedImageSize.height);
    // Add the offset for the row/col
    int col = _index % _gridSize;
    int row = (_index / _gridSize).floor();
    final indexedOffset =
        Offset(-paddedImageSize.width * col, -paddedImageSize.height * row);
    return originOffset + indexedOffset;
  }

  int newIndex = 5;

  /// Converts a swipe direction into a new index
  void _handleSwipe(Offset dir) {
    // Calculate new index, y swipes move by an entire row, x swipes move one index at a time
    newIndex = _index;
    if (dir.dy != 0) newIndex += _gridSize * (dir.dy > 0 ? -1 : 1);
    if (dir.dx != 0) newIndex += (dir.dx > 0 ? -1 : 1);
    // After calculating new index, exit early if we don't like it...
    if (newIndex < 0 || newIndex > _imgCount - 1) {
      return; // keep the index in range
    }
    if (dir.dx < 0 && newIndex % _gridSize == 0) {
      return; // prevent right-swipe when at right side
    }
    if (dir.dx > 0 && newIndex % _gridSize == _gridSize - 1) {
      return; // prevent left-swipe when at left side
    }
    _lastSwipeDir = dir;
    // AppHaptics.lightImpact();
    _setIndex(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    print('MK: newIndex => $newIndex');
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Size imgSize = isLandscape
        ? Size(width * .5, height * .66)
        : Size(width * .66, height * .5);
    imgSize = (widget.imageSize ?? imgSize) * _scale;
    // Get transform offset for the current _index
    const double padding = 10;
    // final padding = $styles.insets.md;//24
    // print('MK: padding => ${padding}');
    var gridOffset = _calculateCurrentOffset(padding, imgSize);
    gridOffset += Offset(0, -MediaQuery.of(context).padding.top / 2);
    final offsetTweenDuration =
        _skipNextOffsetTween ? Duration.zero : swipeDuration;
    final cutoutTweenDuration =
        _skipNextOffsetTween ? Duration.zero : swipeDuration * .5;
    return Consumer<AppProvider>(
        builder: (BuildContext context, AppProvider appPro, _) {
      return SafeArea(
        bottom: false,
        child: _AnimatedCutoutOverlay(
          animationKey: ValueKey(_index),
          cutoutSize: imgSize,
          swipeDir: _lastSwipeDir,
          duration: cutoutTweenDuration,
          opacity: _scale == 1 ? 0.0 : 0,
          enabled: useClipPathWorkAroundForWeb == false,
          child: OverflowBox(
            maxWidth: _gridSize * imgSize.width + padding * (_gridSize - 1),
            maxHeight: _gridSize * imgSize.height + padding * (_gridSize - 1),
            alignment: Alignment.center,
            // Detect swipes in order to change index
            child: EightWaySwipeDetector(
              onSwipe: _handleSwipe,
              threshold: 30,
              // A tween animation builder moves from image to image based on current offset
              child: TweenAnimationBuilder<Offset>(
                tween: Tween(begin: gridOffset, end: gridOffset),
                duration: offsetTweenDuration,
                curve: Curves.elasticInOut,
                builder: (_, value, child) =>
                    Transform.translate(offset: value, child: child),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: _gridSize,
                  childAspectRatio: imgSize.aspectRatio,
                  mainAxisSpacing: padding,
                  crossAxisSpacing: padding,
                  children: List.generate(
                      _imgCount,
                      (index) => StoryItem(
                            story: appPro.stories[index],
                            showTags: index == newIndex,
                          )),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

/// An overlay with a animated cutout in the middle.
/// When animationKey changes, the box animates its size, shrinking then returning to its original size.
/// Uses[_CutoutClipper] to create the cutout.
class _AnimatedCutoutOverlay extends StatelessWidget {
  const _AnimatedCutoutOverlay({
    Key? key,
    required this.child,
    required this.cutoutSize,
    required this.animationKey,
    this.duration,
    required this.swipeDir,
    required this.opacity,
    required this.enabled,
  }) : super(key: key);
  final Widget child;
  final Size cutoutSize;
  final Key animationKey;
  final Offset swipeDir;
  final Duration? duration;
  final double opacity;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Stack(
      children: [
        child,
        Animate(
          effects: [
            CustomEffect(
                builder: _buildAnimatedCutout,
                curve: Curves.easeOut,
                duration: duration)
          ],
          key: animationKey,
          onComplete: (c) => c.reverse(),
          child: IgnorePointer(
              child: Container(color: Colors.black.withOpacity(opacity))),
        ),
      ],
    );
  }

  /// Scales from 1 --> (1 - scaleAmt) --> 1
  Widget _buildAnimatedCutout(BuildContext context, double anim, Widget child) {
    // controls how much the center cutout will shrink when changing images
    const scaleAmt = .25;
    final size = Size(
      cutoutSize.width * (1 - scaleAmt * anim * swipeDir.dx.abs()),
      cutoutSize.height * (1 - scaleAmt * anim * swipeDir.dy.abs()),
    );
    return ClipPath(clipper: _CutoutClipper(size), child: child);
  }
}

/// Creates an overlay with a hole in the middle of a certain size.
class _CutoutClipper extends CustomClipper<Path> {
  _CutoutClipper(this.cutoutSize);

  final Size cutoutSize;

  @override
  Path getClip(Size size) {
    double padX = (size.width - cutoutSize.width) / 2;
    double padY = (size.height - cutoutSize.height) / 2;

    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()
        ..addRRect(
          RRect.fromLTRBR(
            padX,
            padY,
            size.width - padX,
            size.height - padY,
            const Radius.circular(6),
          ),
        )
        ..close(),
    );
  }

  @override
  bool shouldReclip(_CutoutClipper oldClipper) =>
      oldClipper.cutoutSize != cutoutSize;
}

class EightWaySwipeDetector extends StatefulWidget {
  const EightWaySwipeDetector(
      {Key? key,
      required this.child,
      this.threshold = 50,
      required this.onSwipe})
      : super(key: key);
  final Widget child;
  final double threshold;
  final void Function(Offset dir)? onSwipe;

  @override
  State<EightWaySwipeDetector> createState() => _EightWaySwipeDetectorState();
}

class _EightWaySwipeDetectorState extends State<EightWaySwipeDetector> {
  Offset _startPos = Offset.zero;
  Offset _endPos = Offset.zero;
  bool _isSwiping = false;

  void _resetSwipe() {
    _startPos = _endPos = Offset.zero;
    _isSwiping = false;
  }

  void _maybeTriggerSwipe() {
    // Exit early if we're not currently swiping
    if (_isSwiping == false) return;
    // Get the distance of the swipe
    Offset moveDelta = _endPos - _startPos;
    final distance = moveDelta.distance;
    // Trigger swipe if threshold has been exceeded, if threshold is < 1, use 1 as a minimum value.
    if (distance >= max(widget.threshold, 1)) {
      // Normalize the dx/dy values between -1 and 1
      moveDelta /= distance;
      // Round the dx/dy values to snap them to -1, 0 or 1, creating an 8-way directional vector.
      Offset dir = Offset(
        moveDelta.dx.roundToDouble(),
        moveDelta.dy.roundToDouble(),
      );
      widget.onSwipe?.call(dir);
      _resetSwipe();
    }
  }

  void _handleSwipeStart(d) {
    _isSwiping = true;
    _startPos = _endPos = d.localPosition;
  }

  void _handleSwipeUpdate(d) {
    _endPos = d.localPosition;
    _maybeTriggerSwipe();
  }

  void _handleSwipeEnd(d) {
    _maybeTriggerSwipe();
    _resetSwipe();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: _handleSwipeStart,
        onPanUpdate: _handleSwipeUpdate,
        onPanCancel: _resetSwipe,
        onPanEnd: _handleSwipeEnd,
        child: widget.child);
  }
}
