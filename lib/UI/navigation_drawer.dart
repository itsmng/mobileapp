import 'package:flutter/material.dart';
import 'package:mobileapp/UI/authentification.dart';
import 'package:mobileapp/UI/home_page.dart';
import 'package:mobileapp/UI/tickets_page.dart';
import 'package:mobileapp/UI/computers_page.dart';
import 'package:mobileapp/api/model.dart';
import 'package:mobileapp/application.dart';
import 'package:mobileapp/translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawerMenu extends StatelessWidget {
  const NavigationDrawerMenu({super.key});
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  static final _initSession = InitSession();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromARGB(255, 123, 8, 29),
        child: ListView(
          children: <Widget>[
            buildHeader(
              context: context,
              urlImage: "assets/login_logo_itsm.png",
              text: Translations.of(context)!.text('description_application'),
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
                    text: Translations.of(context)!.text('home_title'),
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
                    text: Translations.of(context)!.text('computer'),
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
                  Container(
                    padding: const EdgeInsets.only(bottom: 5, top: 50),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.language),
                          color: Colors.white,
                          iconSize: 30,
                          tooltip: 'French language',
                          onPressed: () {
                            applic.onLocaleChanged!(const Locale('fr', ''));
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ));
                          },
                        ),
                        const Text('French',
                            style: TextStyle(color: Colors.white)),
                        IconButton(
                          icon: const Icon(Icons.language),
                          color: Colors.white,
                          iconSize: 30,
                          tooltip: 'English language',
                          onPressed: () {
                            applic.onLocaleChanged!(const Locale('en', ''));
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ));
                          },
                        ),
                        const Text(
                          'English',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
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
    required BuildContext context,
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
            ),
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                var respos =
                    await _initSession.apiMgmt.logoutFromItsmAPI("killSession");
                if (respos["session"] == "killed") {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove("URL");
                  await prefs.remove("Session-token");
                  await prefs.remove("App-token");
                  await prefs.remove("User-token");

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Authentification()),
                      (Route<dynamic> route) => false,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
