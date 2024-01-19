import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api_service.dart';
import '../../constants.dart';
import '../../models/story.dart';
import '../../providers/app_provider.dart';
import '../../providers/story_provider.dart';
import '../../routes/route_constants.dart';
import '../../routes/session_manager.dart';
import '../../utils/public_methods.dart';
import 'misc_widgets.dart';

class StoryItem extends StatefulWidget {
  const StoryItem({
    super.key,
    required this.story,
    this.showTags = false,
    this.increaseItemSize = false,
  });

  final Story story;
  final bool showTags;
  final bool increaseItemSize;

  @override
  State<StoryItem> createState() => _StoryItemState();
}

class _StoryItemState extends State<StoryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.addListener(() {
      if (_animation.value > 0.55) {
        // toastMessage('Going to the next story');
        if (context.mounted)
          Navigator.pushNamed(context, storiesDetailScreen,
              arguments: {'first_image': bgImage?.path});
        _controller.reset();
      }
    });
    _controller.addStatusListener((status) {
      // if (_animation.value > 0.5) {
      //   toastMessage('Going to the next story');
      //   Navigator.pushNamed(context, storiesDetailScreen);
      // }
      if (status == AnimationStatus.completed) {
        // Navigator.pushNamed(context, storiesDetailScreen);
        _controller.reset();

        // Add logic to navigate to next screen or perform other actions
      }
    });
  }

  File? bgImage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    // _controller.reset();
    _controller.forward();
  }

  double progress = 0;
  List<String> images = [];

  bool isDownloading = false;

  openStory() async {
    if (isDownloading ||
        (widget.story.downloadProgress >= 0 &&
            widget.story.downloadProgress < 100)) {
      return;
    }
    if (widget.story.identifier == null || widget.story.identifier == "") {
      toastMessage('Unable to download story data');
      return;
    }
    setState(() {
      isDownloading = true;
    });
    AppProvider appPro = context.read<AppProvider>();
    File? file = await ApiService().downloadFile(widget.story.identifier!,
        progressCallback: (int val1, int val2) {
      progress = (val1 / val2) * 100;
      widget.story.downloadProgress = progress.toInt();
      (appPro.stories
              .where((element) => element.identifier == widget.story.identifier)
              .toList())
          .forEach((element) {
        element.downloadProgress = progress.toInt();
      });
      // log('MK: in download progress callback');
    });

    if (file != null) {
      String path = await ApiService()
          .extractZipFile(file.path, '${widget.story.identifier}');

      file.delete();
      AppProvider appPro = Provider.of<AppProvider>(context, listen: false);
      prepareStory(context, appPro.genderString, path + subPath, appPro.locale);

      //////below is done because list may contain duplicated now because of testing redundant data
      appPro.stories
          .firstWhere(
              (element) => element.identifier == widget.story.identifier)
          .isDownloaded = true;
    } else {
      toastMessage('Unable to download story data');
    }

    setState(() {
      isDownloading = false;
    });
    // Navigator.pushNamed(context, "storiesDetailScreen");
  }

  @override
  Widget build(BuildContext context) {
    // print('MK: downloading: ${widget.story.downloadProgress}');
    if (widget.story.downloadProgress >= 100) {
      widget.story.downloadProgress = -1;
    }
    final bool showIncreaseItem = widget.increaseItemSize && widget.showTags;
    double increaseValue = 20;
    return Consumer2<AppProvider, StoryProvider>(
        builder: (context, appPro, storyPro, _) {
      return GestureDetector(
        onTap: () async {
          openStory();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 250,
          width: 530,
          // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.only(
            left: showIncreaseItem ? 0 : increaseValue,
            right: showIncreaseItem ? 0 : increaseValue,
            bottom: showIncreaseItem ? increaseValue : increaseValue + 20,
            top: showIncreaseItem ? 0 : increaseValue,
          ),
          padding: EdgeInsets.only(
            top: 4,
            bottom: 10,
            left: 2,
            right: 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: widget.story.storyColor ?? Colors.blueGrey.shade50,
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (bgImage != null)
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Hero(
                          tag: widget.story.identifier!,
                          child: Image.file(
                            bgImage!,
                            fit: BoxFit.fill,
                            // height: 300,
                            height: 300,
                            width: showIncreaseItem ? 360 : 360,
                          ),
                        ),
                      ),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        // if (3.14 *
                        //         (_animation.value > 0.5
                        //             ? 0
                        //             : _animation.value) >
                        //     0)
                        //   log('MK: rotating: ${3.14 * (_animation.value > 0.5 ? 0 : _animation.value)}');
                        return Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(3.14 *
                                (_animation.value > 0.5
                                    ? 0.5
                                    : _animation.value))
                            ..translate(0.0 * (1 - _animation.value), 0.0, 0.0),
                          // Adjust the translation to stop at the middle
                          child: child,
                        );
                      },
                      child: Image.asset(
                        "${getStoryCover(widget.story, appPro.genderString, appPro.locale)}",
                        fit: BoxFit.fill,
                        width: showIncreaseItem ? 360 : 360,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Stack(
                  alignment: Alignment.topRight,
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      "assets/icons/wood_line_icon.png",
                      height: 10,
                      fit: BoxFit.cover,
                    ),
                    if (widget.showTags)
                      Positioned(
                        right: 30,
                        top: 2,
                        child: BuildSlideTransition(
                          curve: Curves.easeInExpo,
                          startPos: -0.2,
                          endPos: 0,
                          animationDuration: showIncreaseItem ? 400 : 200,
                          child: OpenStoryWidget(
                            story: widget.story,
                            isDownloading: widget.story.downloadProgress >= 0 &&
                                widget.story.downloadProgress < 100,
                            progress: widget.story.downloadProgress,
                            openStoryCallback: openStory,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // if (isDownloading) Text('${progress.toInt()}%'),
            ],
          ),
        ),
      );
    });
  }

  prepareStory(
      BuildContext context, String gender, String filePath, String lang) async {
    Story data = widget.story;
    if (!data.isProcessed) {
      String? musicPath;
      String? storyPath;
      String? imgPath;
      String? imgExt;
      num totalPages = 0;
      final input = File(filePath + dataFileName).openRead();
      final listData = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      images.clear();
      for (int i = 1; i < listData.length; i++) {
        for (int j = 0; j < listData[i].length; j++) {
          if (listData[0][j] == gender) {
            images.add(listData[i][j]);
          }
          if (listData[0][j] == musicKey && listData[i][j] != "") {
            musicPath = listData[i][j];
          }
          if (listData[0][j] == storyKey && listData[i][j] != "") {
            storyPath = listData[i][j];
          }
          // if (listData[0][j] == totalPagesKey && listData[i][j] != "") {
          //   totalPages = listData[i][j];
          // }
          if (listData[0][j] == 'image_path' && listData[i][j] != "") {
            imgPath = listData[i][j];
          }
          if (listData[0][j] == 'extension' && listData[i][j] != "") {
            imgExt = listData[i][j];
          }
        }
      }
      Map<String, String> storyData = {};

      if (storyPath != null && storyPath.isNotEmpty) {
        final input = File(filePath + storyPath).openRead();
        final data = await input
            .transform(utf8.decoder)
            .transform(const CsvToListConverter(eol: '\n'))
            .toList();

        for (int i = 1; i < data.length; i++) {
          for (int j = 1; j < data[i].length; j++) {
            if ('${data[0][j]}'.toLowerCase() == lang.toLowerCase()) {
              storyData['${data[i][0]}'] = '${data[i][j]}';
            }
          }
        }
      }
      // log('MK: images: ${images.length} $imgPath $imgExt');
      if (images.length == 0 && imgPath != null && imgExt != null) {
        int i = 1;
        bool imageDirectoryExists;
        bool imageDirectoryWithGenderExists;
        do {
          File imageDirectory = File('$filePath$imgPath$i$imgExt');
          File imageDirectoryWithGender =
              File('$filePath$imgPath${i}_${capitalize(gender)}$imgExt');

          imageDirectoryExists = await imageDirectory.exists();
          imageDirectoryWithGenderExists =
              await imageDirectoryWithGender.exists();

          if (imageDirectoryExists) {
            images.add('$imgPath$i$imgExt');
          }
          if (imageDirectoryWithGenderExists) {
            images.add('$imgPath${i}_${capitalize(gender)}$imgExt');
          }
          i++;
          // log('MK: images: $images for $imageDirectory annd $imageDirectoryWithGender');
        } while (imageDirectoryExists || imageDirectoryWithGenderExists);
      }

      data.basePath = filePath;
      data.musicPath = musicPath;
      data.storyPath = storyPath;
      data.data = storyData;
      // data.totalPages = totalPages;
      data.images = images.map((e) => File(filePath + e)).toList();

      // print("MK: listData: $listData");
      // print("MK: listData Length: ${listData.length} and ${images} and "
      //     "musicPath: $musicPath || storyPath: $storyPath and basePath: $filePath and totalPages: $totalPages");
      data.isProcessed = true;
    } else {
      if (data.itemIndex > -1) {
        data.itemIndex--;
      }
      context.read<StoryProvider>().story = data;
      // log('MK: itemIndex: ${data.itemIndex}');
      if ((data.images.length) > 0) {
        if (data.itemIndex <= 0) {
          bgImage = data.images.first;
        } else if (data.itemIndex >= data.images.length) {
          bgImage = data.images.last;
        } else {
          bgImage = data.images[data.itemIndex + 1];
        }
        setState(() {});
      }
      _startAnimation();
    }
  }
}

class OpenStoryWidget extends StatelessWidget {
  const OpenStoryWidget(
      {super.key,
      required this.story,
      this.isDownloading = false,
      this.progress = 0,
      this.openStoryCallback});

  final Story story;
  final bool isDownloading;
  final int progress;
  final dynamic openStoryCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isNotNullorEmpty(story.pages))
          Transform.translate(
            offset: const Offset(14, 0),
            child: Container(
              height: 50,
              width: 40,
              decoration: const BoxDecoration(
                  // color: Colors.yellow,
                  image: DecorationImage(
                image: AssetImage(
                  "assets/icons/bookmark_icon.png",
                ),
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  // Define the desired color and opacity
                  BlendMode.srcATop, // Define the blend mode
                ),
                fit: BoxFit.fill,
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${story.pages}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "pp",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        GestureDetector(
          onTap: () {
            log('MK: onTap of open story');
            if (openStoryCallback != null) openStoryCallback();
          },
          child: Container(
            height: 50,
            width: story.isDownloaded ? 110 : 140,
            decoration: BoxDecoration(
                // color: Colors.yellow,
                image: DecorationImage(
              image: const AssetImage(
                "assets/icons/bookmark_icon.png",
              ),
              colorFilter: ColorFilter.mode(
                story.isDownloaded ? Colors.yellow : Colors.deepOrangeAccent,
                // Define the desired color and opacity
                BlendMode.srcATop, // Define the blend mode
              ),
              fit: BoxFit.fill,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${isDownloading && progress <= 100 && progress >= 0 ? '${progress}%' : isDownloading ? getString("downloading") : story.isDownloaded ? getString("open") : getString("download")}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: story.isDownloaded
                        ? 16
                        : isDownloading
                            ? 14
                            : 16,
                    color: Colors.white,
                    height: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isNotNullorEmpty(story.size) && !story.isDownloaded)
                  Text(
                    "${story.size}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
