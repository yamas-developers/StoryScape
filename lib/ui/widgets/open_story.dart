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
  const StoryItem({super.key, required this.story, this.showTags = false});

  final Story story;
  final bool showTags;

  @override
  State<StoryItem> createState() => _StoryItemState();
}

class _StoryItemState extends State<StoryItem> {
  double progress = 0;
  List<String> images = [];

  bool isDownloading = false;

  openStory() async {
    if (isDownloading) {
      return;
    }
    if (widget.story.identifier == null || widget.story.identifier == "") {
      toastMessage('Unable to download story data');
      return;
    }
    setState(() {
      isDownloading = true;
    });
    File? file = await ApiService().downloadFile(widget.story.identifier!,
        progressCallback: (int val1, int val2) {
      progress = (val1 / val2) * 100;
      // setState(() {
      // });
      // log('MK: download progress: $progress');
    });

    if (file != null) {
      String path = await ApiService()
          .extractZipFile(file.path, '${widget.story.identifier}');

      // print("MK story data: ${file.path} and path: ${path}");

      file.delete();

      ///after it is extracted

      // setState(() {
      //   temp = File(path + "/extracts/cow_Page_1_Boy.png");
      // });
      AppProvider appPro = Provider.of<AppProvider>(context, listen: false);
      fetchImagesFromCSV(
          context, appPro.genderString, path + subPath, appPro.locale);
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
    return Consumer<AppProvider>(builder: (context, appPro, _) {
      return GestureDetector(
        onTap: () async {
          openStory();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20, top: 0),
          child: Container(
            height: 250,
            width: 530,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding:
                const EdgeInsets.only(top: 6, bottom: 10, left: 0, right: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.blueGrey.shade50,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    "${getStoryCover(widget.story, appPro.genderString, appPro.locale)}",
                    fit: BoxFit.fill,
                    width: 300,
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
                            animationDuration: 200,
                            child: OpenStoryWidget(
                              story: widget.story,
                              isDownloading: isDownloading,
                              progress: progress.toInt(),
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
        ),
      );
    });
  }

  fetchImagesFromCSV(
      BuildContext context, String gender, String filePath, String lang) async {
    Story data = widget.story;
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
    log('MK: images: ${images.length} $imgPath $imgExt');
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
        log('MK: images: $images for $imageDirectory annd $imageDirectoryWithGender');
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
    context.read<StoryProvider>().story = data;
    Navigator.pushNamed(context, storiesDetailScreen);
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
                  "${isDownloading && progress <= 100 ? '${progress}%' : isDownloading ? getString("downloading") : story.isDownloaded ? getString("open") : getString("download")}",
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
