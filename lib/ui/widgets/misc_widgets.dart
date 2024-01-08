import 'package:flutter/material.dart';

class BuildSlideTransition extends StatelessWidget {
  const BuildSlideTransition(
      {Key? key,
      required this.child,
      required this.animationDuration,
      this.startPos = 1.0,
      this.endPos = 0.0,
      this.curve = Curves.elasticInOut})
      : super(key: key);
  final Widget child;
  final int animationDuration;
  final double startPos;
  final double endPos;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: Offset(0, startPos), end: Offset(0, endPos)),
      duration: Duration(milliseconds: animationDuration),
      curve: curve,
      builder: (context, Offset offset, child) {
        return FractionalTranslation(
          translation: offset,
          child: child,
        );
      },
      child: child,
    );
  }
}
