import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stories_app/ui/settings_screen.dart';
import 'package:stories_app/utils/public_methods.dart';

import '../constants.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  // String groupValue = "en";
  String _selectedValue = 'en';

  // List<Map> radioButton = [
  //   {"title":"ENGLISH", "value": "1"},
  //   {"title":"PYCCKNN", "value": "2"},
  //   {"title":"DEUTSCH", "value": "3"},
  //   {"title":"FRENCH", "value": "4"},
  // ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _selectedValue = context.locale.toString();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
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
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: new BoxDecoration(color: secondaryColor),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GradientText(
                              getString('languages'),
                              style: TextStyle(
                                  fontSize: 34, fontFamily: "Al Nile"),
                              gradient: LinearGradient(colors: [
                                gradientColor,
                                gradientColor.withOpacity(0.6),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        // height: 245,
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(langs.length, (index) {
                              return Row(
                                children: [
                                  Radio<String>(
                                    visualDensity: VisualDensity.compact,
                                    activeColor: gradientColor,
                                    // focusColor: Color(0xffFFC331),
                                    fillColor: MaterialStateProperty.all(
                                        gradientColor),
                                    value: langs[index].locale,
                                    groupValue: _selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedValue = value.toString();
                                      });
                                    },
                                  ),
                                  Text('${langs[index].lang.toUpperCase()}'),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setLocale(
                                    context,
                                    langs.firstWhere((element) =>
                                        element.locale == _selectedValue));
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                "assets/icons/accept.png",
                                height: 40,
                                width: 40,
                                fit: BoxFit.contain,
                                // color: Colors.yellow,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    "assets/images/bear.png",
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    "assets/images/fox.png",
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
