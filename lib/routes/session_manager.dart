import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

void toastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: mainColor,
      textColor: secondaryColor,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1);
}

class SessionManager {
  Future<String?> getDataFromSP(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key.isNotEmpty) {
      return prefs.getString(key);
    }
    return null;
  }

  Future<bool?> checkData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key.isNotEmpty) {
      String? data = prefs.getString(key);
      if (data != null) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<bool?> checkBoolData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key.isNotEmpty) {
      bool? data = prefs.getBool(key);
      if (data == true) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  void storeData(String key, dynamic object) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(object);
    print("storeData=>SM=>$jsonString");
    prefs.setString(key, jsonString);
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? saveData = prefs.getString(key);
    return saveData;
  }

  void storeSPData(String key, Map<DateTime, String> object) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> stringMap = {};
    object.forEach((key, value) {
      stringMap[key.toString()] = value;
    });
    String jsonString = jsonEncode(stringMap);
    print("storeSPData$jsonString");

    prefs.setString("CalendarData", jsonString);
  }

  void storeString(String key, String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint("MA: sessionManager=>$data");
    prefs.setString(key, data);
  }

  void removeString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint("MA: sessionManager=>$key");
    prefs.remove(key);
  }

  void reminderDays(String days, String time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint("MA: sessionManager=>reminder$days/time$time}");
    prefs.setString('reminderDays', days);
    prefs.setString('reminderTime', time);
  }

// Future<void> storeUserData(List<UserData> userDataList) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   List<String> userDataStrings = userDataList.map((userData) => userDataToJson(userData)).toList();
//
//   prefs.setStringList('user_data_list', userDataStrings);
// }
// String userDataToJson(UserData userData) {
//   return json.encode({
//     'date': userData.selectedDate,
//     'days': userData,
//     'eachDay': userData.eachDay,
//     'dateOfBirth': userData.dateOfBirth,
//     'reminder': userData.reminder,
//   });
// }
}
