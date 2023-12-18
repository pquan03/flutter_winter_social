import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/recources/auth_api.dart';
import 'package:insta_node_app/views/auth/screens/login.dart';
import 'package:insta_node_app/views/post/screens/saved_post.dart';
import 'package:insta_node_app/views/setting/screens/dark_mode.dart';
import 'package:insta_node_app/views/auth/screens/splash.dart';
import 'package:insta_node_app/views/setting/widgets/setting_item_card.dart';

import '../../../constants/dimension.dart';

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
                  padding:
                      const EdgeInsets.only(bottom: Dimensions.dPaddingMedium),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Instagram settings',
                    style: Theme.of(context).textTheme.headlineMedium,
                  )),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.userPlus),
                  title: 'Follow and Invite Friends'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.bell), title: 'Notifications'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.lock), title: 'Privacy'),
              SettingItemCard(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SavedScreen())),
                  icon: Icon(FontAwesomeIcons.bookmark),
                  title: 'Saved'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.circleUser),
                  title: 'Preferences'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.solidLifeRing), title: 'Help'),
              SettingItemCard(
                  icon: Icon(FontAwesomeIcons.circleInfo), title: 'About'),
              SettingItemCard(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const DarkModeScreen())),
                  icon: Icon(FontAwesomeIcons.moon),
                  title: 'Dark mode'),
              Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.dPaddingMedium),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Logins',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  )),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.dPaddingMedium),
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add account',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .apply(color: Colors.blue),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  // show dialog confirm logout user
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Log out'),
                            content:
                                const Text('Are you sure you want to log out?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary))),
                              TextButton(
                                  onPressed: () async {
                                    await AuthApi().logoutUser();
                                    if (!mounted) return;
                                    // push and remove all screen
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (_) => const SplashPage()),
                                        (route) => false);
                                  },
                                  child: const Text(
                                    'Log out',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                            ],
                          ));
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.dPaddingMedium),
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Log out',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .apply(color: Colors.blue),
                    )),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
