import 'package:flutter/material.dart';
import 'package:mobileapp/UI/navigation_drawer.dart';

class TicketsPage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  TicketsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawer(),
        appBar: AppBar(
          title: const Text('Tickets'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 123, 8, 29),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      );
}
