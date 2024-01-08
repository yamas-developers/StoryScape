import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_app/api/api_service.dart';
import 'package:stories_app/providers/app_provider.dart';
import 'package:stories_app/routes/session_manager.dart';
import 'package:stories_app/utils/public_methods.dart';

import '../constants.dart';
import '../models/story.dart';
import '../routes/custom_text_field_widget.dart';
import '../routes/public_methods.dart';
import 'photo_gallery.dart';
import 'widgets/music_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final numberController = TextEditingController();
  int? selectedNumber;

  void checkTime(context) {
    String time = DateFormat('HH').format(DateTime.now());
    int hour = int.parse(time);
    final appDataProvider = Provider.of<AppProvider>(context, listen: false);
    print("hour$hour");
    if (hour >= 6 && hour < 18) {
      print("It's morning time");
      appDataProvider.dayTime = true;
    } else {
      print("It's night time");
      appDataProvider.dayTime = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkTime(context);
    });
  }

  int currentStoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    log(context.locale.toString());
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.green,
        ),
        body: SafeArea(
          child: Consumer<AppProvider>(
            builder: (context, appPro, child) {
              // appPro.dayTime = false;
              // return PhotoGallery();
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage(appPro.dayTime == true
                            ? "assets/images/day_bg.jpg"
                            : "assets/images/night_bg.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Positioned.fill(
                  //   child: CarouselSlider.builder(
                  //     itemCount: appPro.stories.length,
                  //     options: CarouselOptions(
                  //         aspectRatio: 16 / 9,
                  //         initialPage: 0,
                  //         enableInfiniteScroll: false,
                  //         reverse: false,
                  //         autoPlay: false,
                  //         viewportFraction: 0.5,
                  //         autoPlayCurve: Curves.fastOutSlowIn,
                  //         enlargeCenterPage: true,
                  //         scrollDirection: Axis.horizontal,
                  //         onPageChanged: (index, reason) {
                  //           setState(() {
                  //             currentStoryIndex = index;
                  //           });
                  //         }),
                  //     itemBuilder:
                  //         (BuildContext context, int index, int realIndex) {
                  //       return StoryItem(
                  //         story: appPro.stories[index],
                  //         showTags: currentStoryIndex == index,
                  //       );
                  //     },
                  //   ),
                  // ),
                  PhotoGallery(),
                  ..._buildSideIcons(appPro),
                ],
              );
            },
          ),
        ));
  }

  List<Widget> _buildSideIcons(AppProvider appPro) {
    return [
      Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "settingsScreen");
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              "assets/icons/setting.png",
              height: 45,
              width: 45,
              fit: BoxFit.contain,
              color: secondaryColor,
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: MusicWidget(),
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: GestureDetector(
          onTap: () {
            numberController.clear();
            showAlertDialog(
                context,
                imageColorPrimary,
                secondaryColor,
                5,
                Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: bgColorSecondary,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(18))),
                            child: Icon(
                              Icons.cancel_outlined,
                              color: secondaryColor,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'For Dad and Mom',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: secondaryColor),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Input digits:\n'
                                    'three, five, eight',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: textColorSecondary),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: CustomTextField(
                                      controller: numberController,
                                      hintText: '',
                                      readOnly: false,
                                      filledColor: mainColor,
                                      obscureText: false,
                                      textInputType: TextInputType.text,
                                      lines: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          numberController.clear();
                                        });
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        size: 22,
                                        color: bgColorSecondary,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: 100,
                            //   child: GridView.builder(
                            //     gridDelegate:
                            //         SliverGridDelegateWithFixedCrossAxisCount(
                            //       crossAxisCount: 3,
                            //       mainAxisSpacing: 3,
                            //       crossAxisSpacing: 3,
                            //       childAspectRatio: 100,
                            //       mainAxisExtent: 30,
                            //     ),
                            //     itemCount: 10,
                            //     itemBuilder: (BuildContext context, int index) {
                            //       return GestureDetector(
                            //         onTap: () {
                            //           String number = index.toString();
                            //           print("Selected number: $number");
                            //         },
                            //         child: Container(
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(90),
                            //             color: secondaryColor
                            //           ),
                            //           child: Center(
                            //             child:index >= 9 ?
                            //             Text(
                            //               '0',
                            //               style: TextStyle(
                            //                   fontSize: 24,
                            //                   color: bgColorSecondary),
                            //             ) : Text(
                            //               '${index+1}',
                            //               style: TextStyle(
                            //                   fontSize: 24,
                            //                   color: bgColorSecondary),
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                            true
                                ? Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: GridView.builder(
                                            padding: EdgeInsets.all(6),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 15,
                                              mainAxisSpacing: 10,
                                              childAspectRatio: 1,
                                            ),
                                            itemCount: 12,
                                            itemBuilder: (context, index) {
                                              if (index < 9) {
                                                return buildNumberButton(
                                                    index + 1);
                                              } else if (index == 9 ||
                                                  index == 11) {
                                                return SizedBox(); // Empty SizedBox for the zero button
                                              } else {
                                                return buildNumberButton(
                                                    0); // Zero button
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Wrap(
                                    runSpacing: 10,
                                    spacing: 15,
                                    alignment: WrapAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    children: List.generate(10, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedNumber = index;
                                            if (numberController.text.length <
                                                3) {
                                              numberController.text =
                                                  numberController.text +
                                                      index.toString();
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          // padding: EdgeInsets.all(44),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: secondaryColor),
                                          child: Center(
                                            child: Text(
                                              "$index",
                                              style: TextStyle(
                                                  color: bgColorSecondary,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                0.5);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              "assets/icons/mail.png",
              height: 45,
              width: 45,
              fit: BoxFit.contain,
              color: secondaryColor,
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          // appPro.checkForStories();
          // return;
          List<Story> stories =
              appPro.stories.where((element) => element.isDownloaded).toList();
          showAlertDialog(context, imageColorPrimary, secondaryColor, 5,
              StatefulBuilder(builder: (context, nestedSetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              color: Colors.red.withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (stories.length > 0)
                        Flexible(
                          child: Text(
                            'Downloads'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                        )
                    ],
                  ),
                  Expanded(
                    child: stories.length < 1
                        ? Flexible(
                            child: Text(
                              'No Downloads'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor),
                            ),
                          )
                        : ListView.separated(
                            itemCount: stories.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Image.asset(
                                  "${getStoryCover(stories[index], appPro.genderString, appPro.locale)}",
                                  fit: BoxFit.cover,
                                ),
                                title: Text((stories[index].name ?? '')
                                    // +(stories[index].name ?? '') +
                                    // (stories[index].name ?? ''),
                                    ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    if (isNotNullorEmpty(
                                        stories[index].identifier)) {
                                      _showConfirmation(
                                          stories[index].identifier!,
                                          removeCallback: () {
                                        nestedSetState(() {
                                          stories.remove(stories[index]);
                                        });
                                      });
                                    } else {
                                      toastMessage('Unable to delete data');
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: secondaryColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 4,
                                          blurRadius: 6,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.red),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                color: secondaryColor.withOpacity(0.3),
                                indent: 30,
                                endIndent: 30,
                              );
                            },
                          ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Flexible(
                  //       child: Text(
                  //         'Purchases have been restored\nsuccessfully! Use the "Download"\n'
                  //         'bookmark to get the books',
                  //         style: TextStyle(
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.w400,
                  //             color: secondaryColor),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 32),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: secondaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 4,
                                  blurRadius: 6,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Text(
                              "Got it!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: textColorPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }), 0.7);
        },
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              "assets/icons/download.png",
              height: 45,
              width: 45,
              fit: BoxFit.contain,
              color: secondaryColor,
            ),
          ),
        ),
      ),
    ];
  }

  _showConfirmation(String identifier, {dynamic removeCallback = null}) {
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/mouse.png",
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 120,
                  width: MediaQuery.of(context).size.width * 0.28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "ARE YOU SURE?",
                        style: TextStyle(
                            color: tertiaryColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              bool res = await ApiService()
                                  .deleteDirectory(identifier);
                              if (res) {
                                toastMessage("Deleted successfully");
                                context.read<AppProvider>().checkForStories();
                                if (removeCallback != null) removeCallback();
                              }
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "DELETE",
                              style: TextStyle(
                                  color: yellowColor,
                                  fontWeight: FontWeight.bold,
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
                                  color: textColorPrimary,
                                  fontWeight: FontWeight.bold,
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
  }

  Widget buildNumberButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedNumber = index;
          if (numberController.text.length < 3) {
            numberController.text += index.toString();
          }
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white, // Change to your desired color
        ),
        child: Center(
          child: Text(
            // index != 9 ?
            "$index"
            // : "0"
            ,
            style: TextStyle(
              color: gradientColor, // Change to your desired color
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
