import 'package:flutter/material.dart';
import 'package:mobileapp/UI/authentification.dart';
import 'package:mobileapp/UI/home_page.dart';
import 'package:mobileapp/UI/tickets_page.dart';
import 'package:mobileapp/UI/computers_page.dart';

class NavigationDrawerMenu extends StatelessWidget {
  const NavigationDrawerMenu({super.key});
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        // ignore: prefer_const_constructors
        color: Color.fromARGB(255, 123, 8, 29),
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: "assets/login_logo_itsm.png",
              text: "Application techniciens ITSM-NG",
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const Divider(
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 14),
                  buildMenuItem(
                    text: 'Accueil',
                    icon: Icons.add_to_home_screen,
                    onClicked: () => seletedItem(context, 0),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: 'Tickets',
                    icon: Icons.error_outline,
                    onClicked: () => seletedItem(context, 1),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: 'Computers',
                    icon: Icons.computer,
                    onClicked: () => seletedItem(context, 2),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Divider(
                    color: Colors.white70,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: 'Configuration',
                    icon: Icons.settings,
                    onClicked: () => seletedItem(context, 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildMenuItem(
      {required text, required IconData icon, VoidCallback? onClicked}) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: const TextStyle(color: color),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void seletedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          // ignore: prefer_const_constructors
          builder: (context) => TicketsPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ComputersPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Authentification(),
        ));
        break;
    }
  }

  Widget buildHeader({
    required String urlImage,
    required String text,
  }) {
    return InkWell(
      child: Container(
        padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(urlImage, width: 150),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
