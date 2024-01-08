import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_app/providers/app_provider.dart';
import 'package:stories_app/providers/story_provider.dart';
import 'package:stories_app/ui/widgets/music_widget.dart';
import 'package:stories_app/utils/public_methods.dart';

import '../constants.dart';
import '../models/story.dart';
import '../routes/public_methods.dart';
import '../routes/route_constants.dart';

class StoriesDetailScreen extends StatefulWidget {
  const StoriesDetailScreen({Key? key}) : super(key: key);

  @override
  State<StoriesDetailScreen> createState() => _StoriesDetailScreenState();
}

class _StoriesDetailScreenState extends State<StoriesDetailScreen> {
  String? storyLine;
  File? storyImage;
  String? gender;
  String? name;
  bool endOfStory = false;
  bool showContent = true;
  bool changingStory = false;

  fetchGenderAndName(BuildContext context) {
    final appDataProvider = Provider.of<AppProvider>(context, listen: false);
    gender = getGenderString(appDataProvider.gender);
    String name = appDataProvider.name ?? '';
    String capitalizedName = name.replaceRange(0, 1, name[0].toUpperCase());
    this.name = capitalizedName;
  }

  getNextStoryLine(BuildContext context) {
    final storyPro = Provider.of<StoryProvider>(context, listen: false);

    if (storyPro.story == null) {
      return;
    }
    if (gender == null || name == null) {
      fetchGenderAndName(context);
    }
    Story story = storyPro.story!;
    storyPro.story?.itemIndex++;
    endOfStory =
        true; ////temporary true until no image or content is found to show next

    setState(() {
      changingStory = true;
    });
    if (story.itemIndex < story.images.length) {
      endOfStory = false;
      storyImage = story.images[story.itemIndex];
    }
    if (story.data.containsKey('$gender.page.${story.itemIndex + 1}')) {
      storyLine = story.data['$gender.page.${story.itemIndex + 1}'];
      storyLine = storyLine!.replaceAll('\\n', ' ');
      storyLine = storyLine!.replaceAll('{NAME:P1}', '${name}');
      endOfStory = false;
    }
    if (endOfStory) {
      storyPro.story?.itemIndex--;
    }
    setState(() {
      changingStory = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGenderAndName(context);
      StoryProvider pro = context.read<StoryProvider>();
      AppProvider appPro = context.read<AppProvider>();
      appPro.playStoryAudio(
          (pro.story?.basePath ?? '') + (pro.story?.musicPath ?? ''));
      getNextStoryLine(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    // audioPlayer.dispose();

    super.dispose();
  }

  _moveBackword(StoryProvider storyPro) {
    storyPro.story?.itemIndex -= 2;
    getNextStoryLine(context);
  }

  _moveForward() {
    getNextStoryLine(context);
  }

  _hideAndShowContent() {
    setState(() {
      showContent = !showContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<AppProvider>(context, listen: false).stopStoryAudio();
        return await Future.value(true);
      },
      child: SafeArea(
        child: Consumer<StoryProvider>(
            builder: (BuildContext context, StoryProvider storyPro, _) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        storyImage != null ? Colors.green : Colors.transparent,
                    image: storyImage != null
                        ? null
                        : DecorationImage(
                            image: AssetImage(backgroundImagePath),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // if (storyImage != null)
                      AnimatedOpacity(
                        opacity: changingStory ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          // height: 330,
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            image: storyImage == null
                                ? null
                                : DecorationImage(
                                    image: FileImage(storyImage!),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  _moveBackword(storyPro);
                                },
                                // child: Container(
                                //   color: Colors.green.shade50,
                                // ),
                              )),
                          Expanded(
                              flex: 3,
                              child: InkWell(
                                onTap: () {
                                  _hideAndShowContent();
                                },
                                // child: Container(
                                //   color: Colors.red.shade50,
                                // ),
                              )),
                          Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  _moveForward();
                                },
                                // child: Container(
                                //   color: Colors.blue.shade50,
                                // ),
                              )),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedOpacity(
                          opacity: showContent ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 10),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(minHeight: 80),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: secondaryColor.withOpacity(0.75),
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: Text(
                                              (storyLine ?? '--')
                                              //+(storyLine ?? '--') +
                                              // (storyLine ?? '--')
                                              ,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: blackColor,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        if ((storyPro.story?.itemIndex ?? 0) >
                                            0)
                                          InkWell(
                                            onTap: () {
                                              _moveBackword(storyPro);
                                            },
                                            child: Image.asset(
                                              "assets/icons/arrow_left.png",
                                              height: 55,
                                              width: 55,
                                              fit: BoxFit.contain,
                                              color: secondaryColor,
                                            ),
                                          )
                                        else
                                          SizedBox(
                                            width: 20,
                                          ),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        if (!endOfStory)
                                          InkWell(
                                            onTap: () {
                                              _moveForward();
                                            },
                                            child: Image.asset(
                                              "assets/icons/arrow_right.png",
                                              height: 55,
                                              width: 55,
                                              fit: BoxFit.contain,
                                              color: secondaryColor,
                                            ),
                                          )
                                        else
                                          SizedBox(
                                            width: 20,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: AnimatedOpacity(
                    opacity: showContent ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, storiesScreen);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: secondaryColor,
                                              width: 2.5),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Text(
                                          "${(storyPro.story?.itemIndex ?? 0) + 1}",
                                          style: TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      if ((storyPro.story?.pages ?? 0) != 0)
                                        Text(
                                          "${storyPro.story?.pages}",
                                          style: TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Image.asset(
                                    "assets/icons/apps.png",
                                    height: 26,
                                    width: 26,
                                    fit: BoxFit.contain,
                                    color: secondaryColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "informationScreen");
                                  },
                                  child: Image.asset(
                                    "assets/icons/info.png",
                                    height: 26,
                                    width: 26,
                                    fit: BoxFit.contain,
                                    color: secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: mainColor),
                                    padding: const EdgeInsets.all(8),
                                    child: Image.asset(
                                      "assets/icons/open-book.png",
                                      height: 25,
                                      width: 25,
                                      fit: BoxFit.contain,
                                      color: secondaryColor,
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(vertical: 4),
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //         borderRadius: BorderRadius.circular(30),
                                  //         color: bgColorPrimary),
                                  //     padding: const EdgeInsets.all(8),
                                  //     child: Image.asset(
                                  //       "assets/icons/mic.png",
                                  //       height: 25,
                                  //       width: 25,
                                  //       fit: BoxFit.contain,
                                  //       color: secondaryColor,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(30),
                                  //       color: bgColorPrimary),
                                  //   padding: const EdgeInsets.all(8),
                                  //   child: Image.asset(
                                  //     "assets/icons/headphones.png",
                                  //     height: 25,
                                  //     width: 25,
                                  //     fit: BoxFit.contain,
                                  //     color: secondaryColor,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: AnimatedOpacity(
                    opacity: showContent ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showAlertDialog(
                                context,
                                secondaryColor,
                                Colors.transparent,
                                0,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/mouse.png",
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(
                                          height: 120,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.28,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                "ARE YOU LEAVING?",
                                                style: TextStyle(
                                                    color: tertiaryColor,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 20),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      // Navigator.popUntil(context, ModalRoute.withName('homeScreen'));
                                                      Navigator.of(context)
                                                          .popUntil((route) =>
                                                              route.isFirst);
                                                    },
                                                    child: const Text(
                                                      "YES",
                                                      style: TextStyle(
                                                          color: yellowColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 28,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "NO",
                                                      style: TextStyle(
                                                          color:
                                                              textColorPrimary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                                0.5);
                          },
                          child: Image.asset(
                            "assets/icons/home.png",
                            height: 40,
                            width: 40,
                            fit: BoxFit.contain,
                            color: secondaryColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        MusicWidget()
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
