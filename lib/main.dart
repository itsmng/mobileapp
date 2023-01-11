//import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobileapp/UI/authentification.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentification API',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: const Color.fromARGB(255, 254, 255, 255),
        // scaffoldBackgroundColor: const Color.fromARGB(255, 174, 12, 42)
      ),
     
      home: const Authentification(),
    );
  }
}
