import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_app/routes/session_manager.dart';
import 'package:stories_app/ui/widgets/music_widget.dart';
import 'package:stories_app/utils/public_methods.dart';

import '../constants.dart';
import '../providers/app_provider.dart';
import '../routes/custom_text_field_widget.dart';
import '../routes/public_methods.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final nameController = TextEditingController();
  Genders? gender;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AppProvider dataPro = Provider.of<AppProvider>(context, listen: false);

      if (dataPro.name != null) {
        nameController.text = dataPro.name!;
      }
      if (dataPro.gender != null) {
        gender = dataPro.gender;
      }

      print("gender: ${dataPro.gender} and name: ${nameController.text}");
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appDataProvider, _) {
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 28),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GradientText(
                                  getString('settings').toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 40, fontFamily: "Al Nile"),
                                  gradient: LinearGradient(colors: [
                                    gradientColor,
                                    gradientColor.withOpacity(0.6),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  getString("child_name"),
                                  style: TextStyle(
                                      color: textColorSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: CustomTextField(
                                    controller: nameController,
                                    hintText: getString('name'),
                                    readOnly: false,
                                    filledColor: Color(0xFFECF1D3),
                                    obscureText: false,
                                    textInputType: TextInputType.text,
                                    lines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  getString("gender"),
                                  style: TextStyle(
                                      color: textColorSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            gender = Genders.Boy;
                                          });
                                        },
                                        child: Image.asset(
                                          "assets/icons/male.png",
                                          height:
                                              gender == Genders.Boy ? 45 : 40,
                                          width:
                                              gender == Genders.Boy ? 45 : 40,
                                          fit: BoxFit.contain,
                                          color: gender == Genders.Boy
                                              ? imageColorPrimary
                                              : imageColorPrimary
                                                  .withOpacity(0.5),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            gender = Genders.Girl;
                                          });
                                        },
                                        child: Image.asset(
                                          "assets/icons/female.png",
                                          height:
                                              gender == Genders.Girl ? 45 : 40,
                                          width:
                                              gender == Genders.Girl ? 45 : 40,
                                          fit: BoxFit.contain,
                                          color: gender == Genders.Girl
                                              ? gradientColor
                                              : gradientColor.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (nameController.text.isEmpty) {
                                      toastMessage(
                                          getString("enter_child_name"));
                                    } else if (gender == null ||
                                        !(gender is Genders)) {
                                      toastMessage(getString("select_gender"));
                                    } else {
                                      appDataProvider.gender = gender;

                                      appDataProvider.name =
                                          nameController.text;
                                      Navigator.pop(context);
                                      // Navigator.pushAndRemoveUntil(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const HomeScreen()),
                                      //   (route) => false,
                                      // );
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/icons/ok_arrow.png",
                                    height: 65,
                                    width: 65,
                                    fit: BoxFit.contain,
                                    color: gradientColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
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
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "languagesScreen");
                      },
                      child: Image.asset(
                        "assets/icons/world.png",
                        height: 40,
                        width: 40,
                        fit: BoxFit.contain,
                        color: secondaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showAlertDialog(
                            context,
                            yellowColor,
                            Colors.transparent,
                            0,
                            Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: bgColorSecondary,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight:
                                                  Radius.circular(18))),
                                      child: Icon(
                                        Icons.cancel_outlined,
                                        color: secondaryColor,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          getString("settings_info"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 2,
                                            leadingDistribution:
                                                TextLeadingDistribution
                                                    .proportional,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ),
                            0.8);
                      },
                      child: Image.asset(
                        "assets/icons/question.png",
                        height: 40,
                        width: 40,
                        fit: BoxFit.contain,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: MusicWidget(),
            ),
          ],
        )),
      );
    });
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

class BookCoverAnimation extends StatefulWidget {
  @override
  _BookCoverAnimationState createState() => _BookCoverAnimationState();
}

class _BookCoverAnimationState extends State<BookCoverAnimation>
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

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        // Add logic to navigate to next screen or perform other actions
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startAnimation,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          log('MK: rotating: ${3.14 * (_animation.value > 0.5 ? 0 : _animation.value)}');
          return Transform(
            alignment: Alignment.centerLeft,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                  3.14 * (_animation.value > 0.5 ? 0.5 : _animation.value))
              ..translate(0.0 * (1 - _animation.value), 0.0,
                  0.0), // Adjust the translation to stop at the middle
            child: child,
          );
        },
        child: Image.asset(
          "assets/covers/cow_boy_en.png",
          fit: BoxFit.fill,
          width: 360,
        ), // Replace with your image asset
      ),
    );
  }
}
