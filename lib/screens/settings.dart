import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/recources/auth_api.dart';
import 'package:insta_node_app/screens/dark_mode.dart';
import 'package:insta_node_app/screens/splash.dart';
import 'package:insta_node_app/widgets/setting_item_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
      title: 'Settings',
      child: ListView(children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Instagram settings',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  )),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.userPlus),
                  title: 'Follow and Invite Friends'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.bell),
                  title: 'Notifications'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.lock),
                  title: 'Privacy'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.photoFilm),
                  title: 'Suggested content'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.circleUser),
                  title: 'Preferences'),
              SettingItemCard(
                  icon:
                      Icon(FontAwesomeIcons.solidLifeRing),
                  title: 'Help'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.circleInfo),
                  title: 'About'),
              SettingItemCard(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DarkModeScreen())), 
                  icon: Icon(FontAwesomeIcons.moon),
                  title: 'Dark mode'),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Logins',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  )),
              GestureDetector(
                onTap: () {
                  print('Add account');
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add account',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  // show dialog confirm logout user
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Log out'),
                            content: const Text(
                                'Are you sure you want to log out?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () async {
                                    await AuthApi().logoutUser();
                                    if (!mounted) return;
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const SplashPage()));
                                  },
                                  child: const Text('Log out', style: TextStyle(color: Colors.blue),)),
                            ],
                          ));
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Log out',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
