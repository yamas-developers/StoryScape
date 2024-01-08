import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_app/providers/story_provider.dart';

import '../constants.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({Key? key}) : super(key: key);

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  // List<String> storiesItems = [
  //   "assets/images/story1.jpg",
  //   "assets/images/story2.jpg",
  //   "assets/images/story3.jpg",
  //   "assets/images/story4.jpg",
  //   "assets/images/story5.jpg",
  //   "assets/images/story6.png",
  //   "assets/images/story7.jpg",
  //   "assets/images/story8.png",
  //   "assets/images/story9.png",
  //   "assets/images/story10.jpg",
  //   "assets/images/story11.jpg",
  // ];
  int selectedStory = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
        builder: (BuildContext context, StoryProvider storyPro, _) {
      return SafeArea(
        child: Scaffold(
            body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 5),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ((storyPro.story?.images.length) ?? 0) == 0
                            ? Center(
                                child: Text('No images available',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    )))
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 1,
                                        crossAxisSpacing: 1,
                                        childAspectRatio: 1,
                                        mainAxisExtent: 157),
                                itemCount: (storyPro.story?.images.length) ?? 0,
                                reverse: false,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedStory = index;
                                        });
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Container(
                                              // height: 105,
                                              // width: 195,
                                              decoration: BoxDecoration(
                                                color: secondaryColor,
                                                border: Border.all(
                                                    color: selectedStory ==
                                                            index
                                                        ? secondaryColor
                                                        : Colors.transparent,
                                                    width: 4),
                                                image: new DecorationImage(
                                                  image: new FileImage(
                                                    (storyPro
                                                        .story?.images[index])!,
                                                  ),
                                                  scale: 2,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/icons/bookmark.png",
                                                        height: 50,
                                                        width: 30,
                                                        fit: BoxFit.cover,
                                                        color: secondaryColor,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 8.0),
                                                        child: Text(
                                                          "${index + 1}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              color:
                                                                  blackColor),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ));
                                },
                                // crossAxisCount: 3,
                                // padding: const EdgeInsets.all(0),
                                // mainAxisSpacing: 0,
                                // crossAxisSpacing: 0,
                                // children: storiesItems.map((url) {
                                //   return Align(
                                //     alignment: Alignment.center,
                                //     child: Container(
                                //       height: 105,
                                //       width: 195,
                                //       decoration: new BoxDecoration(
                                //         image: new DecorationImage(
                                //           image: new AssetImage("assets/images/stories_item4.jpg"),
                                //           fit: BoxFit.cover,
                                //         ),
                                //       ),
                                //       child: Stack(
                                //         children: [
                                //           Align(
                                //               alignment: Alignment.topLeft,
                                //               child: Stack(
                                //                 alignment: Alignment.center,
                                //                 children: [
                                //                   Image.asset(
                                //                     "assets/icons/bookmark.png",
                                //                     height: 34,
                                //                     width: 34,
                                //                     fit: BoxFit.contain,
                                //                     color: secondaryColor,
                                //                   ),
                                //                   Text(
                                //                     "2",
                                //                     style: TextStyle(
                                //                         fontWeight: FontWeight.bold,
                                //                         color: Colors.black
                                //                     ),
                                //                   )
                                //                 ],
                                //               )
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //   );
                                // }).toList(),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    "assets/icons/cancel.png",
                    height: 38,
                    width: 38,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        )),
      );
    });
  }
}
