//import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobileapp/UI/authentification.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobileapp/locale/application.dart';
import 'package:mobileapp/locale/translations.dart';

void main() => runApp(const MyApp());

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
