import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_app/providers/app_provider.dart';

import '../constants.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  int? currentIndex;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<AppProvider>(
      builder: (context, appDataProvider, child) {
        return Stack(
          children: [
            Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage(backgroundImagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    // height: 330,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage(
                          "assets/images/stories_item6.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CarouselSlider.builder(
                itemCount: 5,
                carouselController: _controller,
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  viewportFraction: 0.9,
                  // onPageChanged: (index, reason) {
                  //   setState(() {
                  //     currentIndex = index;
                  //     print("index$index");
                  //   });
                  // },
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  if (index == 0) {
                    currentIndex = index;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 33),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "GENERAL",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: mainColor),
                              )
                            ],
                          ),
                        ),
                        SliderItemWidget(
                          image: "assets/icons/apps.png",
                          title: "CONTENT",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/info.png",
                          title: "WATCH THIS TUTORIAL",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/open-book.png",
                          title: "READ THE STORY",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/mic.png",
                          title: "RECORD THE STORY",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/headphones.png",
                          title: "LISTEN TO THE RECORDING",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/home.png",
                          title: "RETURN TO CAROUSAL",
                          index: index,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  } else if (index == 1) {
                    currentIndex = index;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 33),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "READING",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: mainColor),
                              )
                            ],
                          ),
                        ),
                        SliderItemWidget(
                          image: "assets/icons/required.png",
                          title:
                              "TO SWITCH BETWEEN PAGES TAP ON ARROW BUTTONS,\n"
                              "RIGHT/LEFT OF THE SCREEN, OR SWIPE (SLIDE ACROSS THE SCREEN)",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/required.png",
                          title: "TAP IN THE CENTER TO HIDE THE TEXT",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/required.png",
                          title: "USE CONTENTS TO JUMP TO A PARTICULAR SCREEN",
                          index: index,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  } else if (index == 2) {
                    currentIndex = index;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 33),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "READING",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: mainColor),
                              )
                            ],
                          ),
                        ),
                        SliderItemWidget(
                          image: "assets/icons/record.png",
                          title:
                              "TO SWITCH BETWEEN PAGES TAP ON ARROW BUTTONS,\n"
                              "RIGHT/LEFT OF THE SCREEN, OR SWIPE (SLIDE ACROSS THE SCREEN)",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/stop.png",
                          title: "TAP IN THE CENTER TO HIDE THE TEXT",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/required1.png",
                          title:
                              "RECORDING DOES NOT STOP WHEN YOU SWITCH BETWEEN PAGES.\n"
                              "YOU CAN STOP RECORDING AND RE-RECORD A PAGE",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/required1.png",
                          title: "TIMER SHOW TIMING FOR CURRENT PAGE",
                          index: index,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  } else if (index == 3) {
                    currentIndex = index;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 33),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "RECORDINNG",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: mainColor),
                              )
                            ],
                          ),
                        ),
                        SliderItemWidget(
                          image: "assets/icons/required1.png",
                          title: "MUSIC IS OFF DURING THE RECORDING",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/required1.png",
                          title:
                              "WHEN YOU ARE DONE WITH RECORDING YOU CAN LISTEN TO IT AND EDIT IT, IF NEED",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/required1.png",
                          title: "TAP TO STOP EDITING",
                          index: index,
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    );
                  } else if (index == 4) {
                    currentIndex = index;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 33),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "RECORDING",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: mainColor),
                              )
                            ],
                          ),
                        ),
                        SliderItemWidget(
                          image: "assets/icons/required1.png",
                          title:
                              "FIND A QUITE PLACE. DO NOT CLOSE THE MICROPHONE",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/required1.png",
                          title: "SPEAK CLEARLY AND DISTINCTLY.",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/required1.png",
                          title:
                              "ONLY SWITCH TO THE NEXT PAGE AFTER YOU FINISH WITH THE CURRENT ONE.\n"
                              "OTHERWISE, THE RECORDING WILL BE CUT OFF.",
                          index: index,
                        ),
                        SliderItemWidget(
                          image: "assets/icons/required1.png",
                          title:
                              "FOR A HIGH-QUALITY RECORDING USE A HEADSET WITH A MICROPHONE",
                          index: index,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  }
                  return Text("data");
                },
              ),
              // ListView.builder(
              //   itemCount: 5,
              //   scrollDirection: Axis.horizontal,
              //   itemBuilder: (context, index){
              //     return Padding(
              //       padding: const EdgeInsets.all(40),
              //       child: Container(
              //         height: 290,
              //         width: 300,
              //         child: Image.asset(
              //           "assets/images/stories_item1.jpg",
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     );
              //   },
              // )
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    "assets/icons/cancel.png",
                    height: 35,
                    width: 35,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 4),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: currentIndex == index
                                ? secondaryColor
                                : Colors.transparent,
                            border:
                                Border.all(color: secondaryColor, width: 3)),
                      ),
                    );
                  })
                ],
              ),
            )
          ],
        );
      },
    ));
  }
}

class SliderItemWidget extends StatelessWidget {
  const SliderItemWidget({
    super.key,
    required this.title,
    required this.image,
    required this.index,
  });

  final String title;
  final String image;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 70,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              height: 22,
              width: 22,
              color: index == 0 || index == 1 ? secondaryColor : null,
            ),
          ),
          SizedBox(
            width: 320,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
