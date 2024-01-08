import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stories_app/constants.dart';
import 'package:stories_app/providers/app_provider.dart';
import 'package:stories_app/ui/home_screen.dart';
import 'package:stories_app/ui/settings_screen.dart';

import 'providers/story_provider.dart';
import 'routes/router_helper.dart' as router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales:
            List.generate(langs.length, (index) => Locale(langs[index].locale)),
        path: translationsPath,
        fallbackLocale: Locale(langs.first.locale),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // setLocale(context, langs.first);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => StoryProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appDataProvider, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await Provider.of<AppProvider>(context, listen: false)
                .init(context.locale.toString());
          });
          return MaterialApp(
            title: 'Stories App for Kids',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
                fontFamily: "Hiragino Mincho ProN"),
            home: SafeArea(
              child: appDataProvider.initialized ?? false
                  ? const HomeScreen()
                  : const SettingsScreen(),
            ),
            onGenerateRoute: router.generateRoute,
          );
        },
      ),
    );
  }
}
