import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

showAlertDialog(context, Color bgColor,Color borderColor,double borderWidth, Widget child, double width,
    {okButtonText = 'Ok',
    onPress = null,
    showCancelButton = true,
    dismissible = true}) {
  ////VEHICLE DATA
  showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: dismissible,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      transitionBuilder: (_, anim, __, child) {
        var begin = 0.5;
        var end = 1.0;
        var curve = Curves.bounceOut;
        if (anim.status == AnimationStatus.reverse) {
          curve = Curves.fastLinearToSlowEaseIn;
        }
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return ScaleTransition(
          scale: anim.drive(tween),
          child: child,
        );
      },
      pageBuilder: (BuildContext alertContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(dismissible);
              },
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: borderColor,
                        width: borderWidth,
                      )),
                  child: SingleChildScrollView(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Material(
                        child: Container(
                          color: bgColor,
                          // padding: const EdgeInsets.all(5),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      });
}
