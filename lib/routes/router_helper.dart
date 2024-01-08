import 'package:flutter/material.dart';
import 'package:stories_app/routes/route_constants.dart';
import 'package:stories_app/ui/home_screen.dart';

import '../ui/information_screen.dart';
import '../ui/languages_screen.dart';
import '../ui/settings_screen.dart';
import '../ui/stories_detail_screen.dart';
import '../ui/stories_screen.dart';
import 'animate_route.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (BuildContext buildContext) {
        return const HomeScreen(); //splash screen
      });
    case homeScreen:
      debugPrint(settings.name);
      return routeOne(
          settings: settings,
          widget: const HomeScreen(),
          routeName: homeScreen);
    case storiesDetailScreen:
      debugPrint(settings.name);
      return routeOne(
          settings: settings,
          widget: const StoriesDetailScreen(),
          routeName: storiesDetailScreen);
    case settingsScreen:
      debugPrint(settings.name);
      return routeOne(
          settings: settings,
          widget: const SettingsScreen(),
          routeName: settingsScreen);
    case languagesScreen:
      debugPrint(settings.name);
      return routeOne(
          settings: settings,
          widget: const LanguagesScreen(),
          routeName: languagesScreen);
    case storiesScreen:
      debugPrint(settings.name);
      return routeOne(
          settings: settings,
          widget: const StoriesScreen(),
          routeName: storiesScreen);
    case informationScreen:
      debugPrint(settings.name);
      return routeOne(
          settings: settings,
          widget: const InformationScreen(),
          routeName: informationScreen);
    default:
      debugPrint("default");
      return routeOne(
          settings: settings,
          widget: const HomeScreen(), //login screen
          routeName: homeScreen);
  }
}
