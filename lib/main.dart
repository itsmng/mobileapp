import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobileapp/UI/authentification.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobileapp/api/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'application.dart';
import 'translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  return runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SpecificLocalizationDelegate? _localeOverrideDelegate;

  @override
  void initState() {
    super.initState();

    _localeOverrideDelegate = SpecificLocalizationDelegate(
        Locale(Platform.localeName.substring(0, 2), ''));
    final initSession = InitSession();
    initSession.apiMgmt
        .saveStringData("language", Platform.localeName.substring(0, 2));

    ///
    /// Let's save a pointer to this method, should the user wants to change its language
    /// We would then call: applic.onLocaleChanged(new Locale('en',''));
    ///
    applic.onLocaleChanged = onLocaleChange;
  }

  getDefaultLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _localeOverrideDelegate = SpecificLocalizationDelegate(
          Locale(prefs.getString("language").toString(), ''));
    });
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = SpecificLocalizationDelegate(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: const Color.fromARGB(255, 254, 255, 255),
      ),
      localizationsDelegates: [
        _localeOverrideDelegate!,
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: applic.supportedLocales(),
      home: const Authentification(),
    );
  }
}
