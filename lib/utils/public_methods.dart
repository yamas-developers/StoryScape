import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_app/providers/app_provider.dart';
import 'package:stories_app/routes/session_manager.dart';

import '../constants.dart';
import '../models/language.dart';
import '../models/story.dart';
import '../routes/public_methods.dart';

bool isValidGenderString(String? value) {
  return value == BOY || value == GIRL;
}

String getGenderString(Genders? value) {
  return value == Genders.Boy ? BOY : GIRL;
}

String getString(String key, {List<String>? args}) {
  if (key != '') {
    try {
      return tr(key.toLowerCase(), args: args);
    } catch (e) {
      print(e);
      return key;
    }
  } else {
    return '';
  }
}

setLocale(BuildContext context, Language loc) async {
  String currentLocale = context.locale.toString();
  print("MJ: localization: ${currentLocale}");
  if (currentLocale != loc.locale) {
    await context.setLocale(Locale(loc.locale));
    context.read<AppProvider>().locale = loc.locale;
    toastMessage(getString('language__current_lang'));
  }
}

getStoryCover(Story story, String gender, String lang) {
  if (story.covers.containsKey('cover_${gender}_$lang')) {
    return story.covers['cover_${gender}_$lang'];
  } else {
    return story.covers['cover_${gender}_en'];
  }
}

isNotNullorEmpty(String? val) {
  return val != null && val != '';
}

String capitalize(String? val) {
  if (val == null) return '';
  String capitalizedName = val.replaceRange(0, 1, val[0].toUpperCase());
  return capitalizedName;
}
