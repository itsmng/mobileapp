//import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobileapp/UI/authentification.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobileapp/UI/home_page.dart';
import 'package:mobileapp/api/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'application.dart';
import 'translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? url = prefs.getString("URL");
  String? appToken = prefs.getString("App-token");
  String? userToken = prefs.getString("User-token");

  if ((url == null || url.isEmpty) &&
      (appToken == null || appToken.isEmpty) &&
      (userToken == null || userToken.isEmpty)) {
    return runApp(const MyApp());
  } else {
    return runApp(const MyApp2());
  }
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
    _localeOverrideDelegate =
        const SpecificLocalizationDelegate(Locale('en', ''));

    ///
    /// Let's save a pointer to this method, should the user wants to change its language
    /// We would then call: applic.onLocaleChanged(new Locale('en',''));
    ///
    applic.onLocaleChanged = onLocaleChange;
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
        // scaffoldBackgroundColor: const Color.fromARGB(255, 174, 12, 42)
      ),
      localizationsDelegates: [
        _localeOverrideDelegate!,
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: applic.supportedLocales(),
      home: const Authentification(),
    );
  }
}

class MyApp2 extends StatefulWidget {
  const MyApp2({super.key});

  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  SpecificLocalizationDelegate? _localeOverrideDelegate;

  @override
  void initState() {
    super.initState();

    _localeOverrideDelegate = SpecificLocalizationDelegate(
        Locale(Platform.localeName.substring(0, 2), ''));
    final initSession = InitSession();
    initSession.apiMgmt
        .saveStringData("language", Platform.localeName.substring(0, 2));
    //getDefaultLanguage();

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
        // scaffoldBackgroundColor: const Color.fromARGB(255, 174, 12, 42)
      ),
      localizationsDelegates: [
        _localeOverrideDelegate!,
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: applic.supportedLocales(),
      home: const HomePage(),
    );
  }
}
