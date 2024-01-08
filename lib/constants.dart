import 'package:flutter/material.dart';

import 'models/language.dart';

const Color mainColor = Color(0xffB0D44E);
const Color primaryColor = Color(0xff007399);
const Color secondaryColor = Color(0xffffffff);
const Color blackColor = Color(0xff000000);
const Color bgColorPrimary = Color(0xffc8c8c8);
const Color bgColorSecondary = Color(0xFFFED32E);
const Color blueColor = Color(0xff065ec2);
const Color redColor = Color(0xffbd2727);
const Color yellowColor = Color(0xffBDD960);
const Color textColorPrimary = Color(0xffFFBF2A);
const Color textColorSecondary = Color(0xFF666754);
const Color imageColorPrimary = Color(0xFFB9D95E);
const Color fontColor = Colors.black54;
const Color tertiaryColor = Color(0xFF75776C);
const Color gradientColor = Color(0xffFFC331);

const GOOGLE_API_KEY = "AIzaSyA7ks8X2YnLcxTuEC3qydL2adzA0NYbl6c";
const DownloadBaseUrl = 'http://mix.nex-nova.com/';
const String GENDER = 'gender';
const String NAME = 'name';
const String BOY = 'boy';
const String GIRL = 'girl';
const String subPath = '/extracts/';
const String musicKey = 'music';
const String storyKey = 'story_name';
const String totalPagesKey = 'total_pages';
const String dataFileName = 'data.csv';
const String translationsPath = 'assets/translations';
const String backgroundImagePath = 'assets/images/bg_image.jpg';

enum Genders { Boy, Girl }

List<Language> langs = [
  Language(locale: 'en', lang: 'English', flag: ''),
  Language(locale: 'ru', lang: 'Русский', flag: ''),
  Language(locale: 'de', lang: 'Deutsch', flag: ''),
  Language(locale: 'fr', lang: 'Français', flag: ''),
  Language(locale: 'it', lang: 'Italiano', flag: ''),
];

List<Map<String, dynamic>> storiesData = [
  {
    'identifier': 'cow_643768478734',
    'name': 'I Can Do It',
    'pages': '39',
    'size': '145 MB',
    'covers': {
      'cover_boy_en': 'assets/covers/cow_boy_en.png',
      'cover_boy_fr': 'assets/covers/cow_boy_fr.png',
      'cover_boy_ru': 'assets/covers/cow_boy_ru.png',
      'cover_boy_de': 'assets/covers/cow_boy_de.png',
      'cover_girl_en': 'assets/covers/cow_girl_en.png',
      'cover_girl_fr': 'assets/covers/cow_girl_fr.png',
      'cover_girl_ru': 'assets/covers/cow_girl_ru.png',
      'cover_girl_de': 'assets/covers/cow_girl_de.png',
    }
  },
  {
    'identifier': 'dolphin_178374892137',
    'name': 'My Friend the Dolphin',
    'pages': '43',
    'size': '165 MB',
    'covers': {
      'cover_boy_en': 'assets/covers/dolphin_boy_en.png',
      'cover_boy_fr': 'assets/covers/dolphin_boy_fr.png',
      'cover_boy_ru': 'assets/covers/dolphin_boy_ru.png',
      'cover_boy_de': 'assets/covers/dolphin_boy_de.png',
      'cover_girl_en': 'assets/covers/dolphin_girl_en.png',
      'cover_girl_fr': 'assets/covers/dolphin_girl_fr.png',
      'cover_girl_ru': 'assets/covers/dolphin_girl_ru.png',
      'cover_girl_de': 'assets/covers/dolphin_girl_de.png',
    }
  },
  {
    'identifier': 'farm_673462761347',
    'name': 'A Guest on the Farm',
    'pages': '46',
    'size': '234 MB',
    'covers': {
      'cover_boy_en': 'assets/covers/farm_boy_en.png',
      'cover_boy_fr': 'assets/covers/farm_boy_fr.png',
      'cover_boy_ru': 'assets/covers/farm_boy_ru.png',
      'cover_boy_de': 'assets/covers/farm_boy_de.png',
      'cover_girl_en': 'assets/covers/farm_girl_en.png',
      'cover_girl_fr': 'assets/covers/farm_girl_fr.png',
      'cover_girl_ru': 'assets/covers/farm_girl_ru.png',
      'cover_girl_de': 'assets/covers/farm_girl_de.png',
    }
  },
  {
    'identifier': 'firefly_273929729378',
    'name': 'Brighter Than a Star',
    'pages': '48',
    'size': '140 MB',
    'covers': {
      'cover_boy_en': 'assets/covers/firefly_boy_en.png',
      'cover_boy_fr': 'assets/covers/firefly_boy_fr.png',
      'cover_boy_ru': 'assets/covers/firefly_boy_ru.png',
      'cover_boy_de': 'assets/covers/firefly_boy_de.png',
      'cover_girl_en': 'assets/covers/firefly_girl_en.png',
      'cover_girl_fr': 'assets/covers/firefly_girl_fr.png',
      'cover_girl_ru': 'assets/covers/firefly_girl_ru.png',
      'cover_girl_de': 'assets/covers/firefly_girl_de.png',
    }
  },

  /////extra below

  {
    'identifier': 'cow_643768478734',
    'name': 'I Can Do It',
    'pages': '39',
    'size': '145 MB',
    'covers': {
      'cover_boy_en': 'assets/covers/cow_boy_en.png',
      'cover_boy_fr': 'assets/covers/cow_boy_fr.png',
      'cover_boy_ru': 'assets/covers/cow_boy_ru.png',
      'cover_boy_de': 'assets/covers/cow_boy_de.png',
      'cover_girl_en': 'assets/covers/cow_girl_en.png',
      'cover_girl_fr': 'assets/covers/cow_girl_fr.png',
      'cover_girl_ru': 'assets/covers/cow_girl_ru.png',
      'cover_girl_de': 'assets/covers/cow_girl_de.png',
    }
  },
  {
    'identifier': 'dolphin_178374892137',
    'name': 'My Friend the Dolphin',
    'pages': '43',
    'size': '165 MB',
    'covers': {
      'cover_boy_en': 'assets/covers/dolphin_boy_en.png',
      'cover_boy_fr': 'assets/covers/dolphin_boy_fr.png',
      'cover_boy_ru': 'assets/covers/dolphin_boy_ru.png',
      'cover_boy_de': 'assets/covers/dolphin_boy_de.png',
      'cover_girl_en': 'assets/covers/dolphin_girl_en.png',
      'cover_girl_fr': 'assets/covers/dolphin_girl_fr.png',
      'cover_girl_ru': 'assets/covers/dolphin_girl_ru.png',
      'cover_girl_de': 'assets/covers/dolphin_girl_de.png',
    }
  },
  {
    'identifier': 'farm_673462761347',
    'name': 'A Guest on the Farm',
    'pages': '46',
    'size': '234 MB',
    'covers': {
      'cover_boy_en': 'assets/covers/farm_boy_en.png',
      'cover_boy_fr': 'assets/covers/farm_boy_fr.png',
      'cover_boy_ru': 'assets/covers/farm_boy_ru.png',
      'cover_boy_de': 'assets/covers/farm_boy_de.png',
      'cover_girl_en': 'assets/covers/farm_girl_en.png',
      'cover_girl_fr': 'assets/covers/farm_girl_fr.png',
      'cover_girl_ru': 'assets/covers/farm_girl_ru.png',
      'cover_girl_de': 'assets/covers/farm_girl_de.png',
    }
  },
  {
    'identifier': 'firefly_273929729378',
    'name': 'Brighter Than a Star',
    'pages': '48',
    'size': '140 MB',
    'covers': {
      'cover_boy_en': 'assets/covers/firefly_boy_en.png',
      'cover_boy_fr': 'assets/covers/firefly_boy_fr.png',
      'cover_boy_ru': 'assets/covers/firefly_boy_ru.png',
      'cover_boy_de': 'assets/covers/firefly_boy_de.png',
      'cover_girl_en': 'assets/covers/firefly_girl_en.png',
      'cover_girl_fr': 'assets/covers/firefly_girl_fr.png',
      'cover_girl_ru': 'assets/covers/firefly_girl_ru.png',
      'cover_girl_de': 'assets/covers/firefly_girl_de.png',
    }
  },

  {
    'identifier': 'cow_643768478734',
    'name': 'I Can Do It',
    'pages': '39',
    'size': '145 MB',
    'covers': {
      'cover_boy_en': 'assets/covers/cow_boy_en.png',
      'cover_boy_fr': 'assets/covers/cow_boy_fr.png',
      'cover_boy_ru': 'assets/covers/cow_boy_ru.png',
      'cover_boy_de': 'assets/covers/cow_boy_de.png',
      'cover_girl_en': 'assets/covers/cow_girl_en.png',
      'cover_girl_fr': 'assets/covers/cow_girl_fr.png',
      'cover_girl_ru': 'assets/covers/cow_girl_ru.png',
      'cover_girl_de': 'assets/covers/cow_girl_de.png',
    }
  },
];
