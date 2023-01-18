import 'package:flutter/material.dart';
import 'package:mobileapp/UI/navigation_drawer.dart';

class ComputersPage extends StatelessWidget {
  const ComputersPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavigationDrawerMenu(),
        appBar: AppBar(
          title: const Text('Computers'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 123, 8, 29),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      );
}
