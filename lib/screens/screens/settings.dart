import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/recources/auth_api.dart';
import 'package:insta_node_app/screens/screens/splash.dart';
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
                        color: Colors.white,
                        fontSize: 18),
                  )),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.userPlus, color: Colors.white),
                  title: 'Follow and Invite Friends'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.bell, color: Colors.white),
                  title: 'Notifications'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.lock, color: Colors.white),
                  title: 'Privacy'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.photoFilm, color: Colors.white),
                  title: 'Suggested content'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.circleUser, color: Colors.white),
                  title: 'Preferences'),
              SettingItemCard(
                  icon:
                      Icon(FontAwesomeIcons.solidLifeRing, color: Colors.white),
                  title: 'Help'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.circleInfo, color: Colors.white),
                  title: 'About'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.moon, color: Colors.white),
                  title: 'Dark mode'),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Logins',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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
                  (showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            color: Colors.black87,
                            height: MediaQuery.sizeOf(context).height * 0.22,
                            width: MediaQuery.sizeOf(context).width * 0.2,
                            child: Column(
                              children: [
                                Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.all(16),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Are you want to log out?',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ))),
                                Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Colors.brown,
                                      border: Border(
                                        top: BorderSide(
                                            width: 1.0, color: Colors.black),
                                        bottom: BorderSide(
                                            width: 1.0, color: Colors.black),
                                      ),
                                    ),
                                    child: TextButton(
                                        onPressed: () async {
                                          await AuthApi().logoutUser();
                                          if (!mounted) return;
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SplashPage()),
                                              (route) => false);
                                        },
                                        child: Text(
                                          'Logout',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ))),
                                Container(
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white),
                                        )))
                              ],
                            ),
                          ),
                        );
                      }));
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
