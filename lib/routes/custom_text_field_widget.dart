import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
    required this.obscureText,
    required this.lines,
    this.suffixIcon,
    this.height = 22,
     this.width=22, required this.filledColor,this.readOnly = false
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final bool obscureText;
  final int lines;
  final IconButton? suffixIcon;
  final double height;
  final double width;
  final Color filledColor;
  final bool readOnly;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode emailFocus=FocusNode();
  FocusNode passwordFocus=FocusNode();
  late FocusNode focus;
  @override
  void initState() {
    // TODO: implement initState
    emailFocus=FocusNode();
    passwordFocus=FocusNode();
    focus=FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.32,
      child: TextFormField(
        controller: widget.controller,
        focusNode: focus,
        decoration: InputDecoration(
          hintText: widget.hintText,
          // label:  RichText(
          //   text: TextSpan(
          //       text: widget.hintText,
          //       style:  GoogleFonts.poppins(
          //         color: blackColor.withOpacity(0.5),
          //         fontWeight: FontWeight.w500,
          //         fontSize: 15,
          //       ),
          //       children: const [
          //         TextSpan(
          //             text: ' *',
          //             style: TextStyle(
          //               color: redColor,
          //             )
          //         )
          //       ]
          //   ),
          // ),

          // labelStyle:  GoogleFonts.poppins(
          //   color: blackColor.withOpacity(0.5),
          //   fontWeight: FontWeight.w500,
          //   fontSize: 15,
          // ),
          contentPadding: const EdgeInsets.only(top: 10,bottom: 10, left: 10),
          errorStyle: const TextStyle(
              color: redColor
          ),
          fillColor: widget.filledColor,
          filled: true,
          hintStyle: TextStyle(
            color: Color(0xFF666754),
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          suffixIcon: widget.suffixIcon,
          enabledBorder: const OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
              borderSide:
              BorderSide(width: 1, color: secondaryColor)),
          errorBorder: const OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
              borderSide:
              BorderSide(width: 1, color: secondaryColor)),
          focusedErrorBorder:const OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
              borderSide:
              BorderSide(width: 1, color: secondaryColor)),
          focusedBorder:const OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: secondaryColor)),
          // isDense: true,
          suffix: widget.suffixIcon,
          border: InputBorder.none,
        ),
        readOnly: widget.readOnly,
        cursorColor: Color(0xFF666754),
        cursorHeight: 20,
        keyboardType: widget.textInputType,
        onFieldSubmitted: (value) {
          if (focus == emailFocus) {
            FocusScope.of(context).requestFocus(passwordFocus);
          } else if (focus == passwordFocus) {
            // Handle submission or other actions
          }
        },
        cursorRadius: const Radius.circular(1),
        cursorWidth: 2,
        maxLines: widget.lines,
        validator: ((value) {
          if (value!.isEmpty) {
            return widget.hintText;
          } else {
            return null;
          }
        }),
        // maxLength: 50,
        // minLines: 1,
        obscureText: widget.obscureText,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
      ),
    );
  }
}
class CustomTextFieldWithoutIcon extends StatefulWidget {
  const CustomTextFieldWithoutIcon({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
    required this.obscureText,
    required this.lines,
    this.suffixIcon,
    this.height = 22,
     this.width=22
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final bool obscureText;
  final int lines;
  final IconButton? suffixIcon;
  final double height;
  final double width;

  @override
  State<CustomTextFieldWithoutIcon> createState() => _CustomTextFieldWithoutIconState();
}

class _CustomTextFieldWithoutIconState extends State<CustomTextFieldWithoutIcon> {
  FocusNode emailFocus=FocusNode();
  FocusNode passwordFocus=FocusNode();
  late FocusNode focus;
  @override
  void initState() {
    // TODO: implement initState
    emailFocus=FocusNode();
    passwordFocus=FocusNode();
    focus=FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: focus,
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.only(top: 10,bottom: 10,left: 12 ),
        errorStyle: const TextStyle(
            color: mainColor
        ),
        fillColor: bgColorPrimary,
        filled: true,
        hintStyle: TextStyle(
          color: secondaryColor.withOpacity(0.5),
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        suffixIcon: widget.suffixIcon,
        enabledBorder: const OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(10)),
            borderSide:
            BorderSide(width: 1, color: secondaryColor)),
        errorBorder: const OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(10)),
            borderSide:
            BorderSide(width: 1, color: secondaryColor)),
        focusedErrorBorder:const OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(10)),
            borderSide:
            BorderSide(width: 1, color: secondaryColor)),
        focusedBorder:const OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: secondaryColor)),
        isDense: true,
        border: InputBorder.none,
      ),
      cursorColor: mainColor,
      cursorHeight: 20,
      keyboardType: widget.textInputType,
      onFieldSubmitted: (value) {
        if (focus == emailFocus) {
          FocusScope.of(context).requestFocus(passwordFocus);
        } else if (focus == passwordFocus) {
          // Handle submission or other actions
        }
      },
      cursorRadius: const Radius.circular(1),
      cursorWidth: 2,
      maxLines: widget.lines,
      validator: ((value) {
        if (value!.isEmpty) {
          return widget.hintText;
        } else {
          return null;
        }
      }),
      // maxLength: 50,
      // minLines: 1,
      obscureText: widget.obscureText,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    );
  }
}
class CustomTextFieldWithIcon extends StatefulWidget {
  const CustomTextFieldWithIcon({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
    required this.obscureText,
    required this.lines,
    this.inputFormatters,
    this.suffixIcon,
    this.height = 22,
    this.width=22, required this.onChanged,
    required this.maxLength,
    this.helperText="",
    this.errorText="",
    // this.image="",
    this.type="",
    this.autoFocus=false,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String errorText;
  final String helperText;
  final TextInputType textInputType;
  final bool obscureText;
  final int lines;
  final IconButton? suffixIcon;
  final double height;
  final String type;
  final ValueSetter<String>? onChanged;
  // final String image;
  final List<TextInputFormatter>? inputFormatters;
  final double width;
  final int maxLength;
  final bool autoFocus;


  @override
  State<CustomTextFieldWithIcon> createState() => _CustomTextFieldWithIconState();
}

class _CustomTextFieldWithIconState extends State<CustomTextFieldWithIcon> {
  FocusNode emailFocus=FocusNode();
  FocusNode passwordFocus=FocusNode();
  late FocusNode focus;
  bool isTyping = false;

  @override
  void initState() {
    // TODO: implement initState
    emailFocus=FocusNode();
    passwordFocus=FocusNode();
    focus=FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: focus,
      onChanged: widget.onChanged,
      // (value) {
      // setState(() {
      //   isTyping = value.isNotEmpty;
      // });
      // },
      autofocus: widget.autoFocus,
      inputFormatters:widget.inputFormatters,style: TextStyle(
      color: secondaryColor
    ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        helperText: widget.type=="password"?widget.helperText:null,
        helperStyle: TextStyle(
            color: secondaryColor
        ),
        contentPadding: const EdgeInsets.only(top: 23,bottom: 1,left: 15),
        errorStyle: const TextStyle(
            color: Colors.red
        ),counterText: "",
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.only(top: 12,bottom: 14,left: 12,right: 12),
        //   child: widget.image.isNotEmpty ? Image.asset(
        //     widget.image,
        //     width: widget.height,
        //     height: widget.width,
        //     color: mainColor,
        //   ):const SizedBox(),
        // ),
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.only(top: 12, bottom: 14, left: 12, right: 12),
        //   child:
        //   // widget.image.isNotEmpty
        //   //     ? ColorFiltered(
        //   //   colorFilter: isTyping
        //   //       ? ColorFilter.mode(mainColor, BlendMode.srcIn)
        //   //       : ColorFilter.mode(Colors.grey, BlendMode.srcIn), // Adjust the colors as needed
        //   //   child:
        //     Image.asset(
        //       widget.image,
        //       width: widget.height,
        //       height: widget.width,
        //       color: mainColor,
        //     ),
        //   // )
        //   //     : null,
        // ),
        // suffixIcon: widget.suffixIcon,
        suffixIcon:
        // ColorFiltered(
        // colorFilter: isTyping
        //     ? ColorFilter.mode(mainColor, BlendMode.srcIn)
        //     : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        // child:
        widget.suffixIcon,
        // ),
        labelStyle:  TextStyle(
          color: secondaryColor.withOpacity(0.4),
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        fillColor: bgColorPrimary,
        filled: true,
        hintStyle: TextStyle(
          color: secondaryColor.withOpacity(0.4),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(12)),
            borderSide:
            BorderSide(width: 1, color: blackColor.withOpacity(0.7),)),
        errorBorder: const OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(12)),
            borderSide:
            BorderSide(width: 2, color: redColor)),
        focusedErrorBorder:const OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(12)),
            borderSide:
            BorderSide(width: 2, color: redColor)),
        focusedBorder:const OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(width: 2,color: mainColor)),
        isDense: true,
        border: InputBorder.none,
      ),
      cursorColor: secondaryColor,
      cursorHeight: 20,
      maxLength: widget.maxLength,
      enableSuggestions: true,
      keyboardType: widget.textInputType,
      onFieldSubmitted: (value) {
        if (focus == emailFocus) {
          FocusScope.of(context).requestFocus(passwordFocus);
        } else if (focus == passwordFocus) {
          // Handle submission or other actions
        }
      },
      cursorRadius: const Radius.circular(1),
      cursorWidth: 2,
      maxLines: widget.lines,
      validator: ((value) {
        if (value!.isEmpty) {
          return widget.hintText;
        } else {
          return widget.errorText;
        }
      }),
      // maxLength: 50,
      // minLines: 1,
      obscureText: widget.obscureText,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    );
  }
}
