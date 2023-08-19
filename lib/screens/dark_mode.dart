import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/providers/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeScreen extends StatefulWidget {
  const DarkModeScreen({super.key});

  @override
  State<DarkModeScreen> createState() => _DarkModeScreenState();
}

class _DarkModeScreenState extends State<DarkModeScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeModel>(context).theme;
    return LayoutScreen(
        title: 'Dark mode',
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async{
                    final Future<SharedPreferences> asynPrefs = SharedPreferences.getInstance();
                    final SharedPreferences prefs = await asynPrefs;
                    prefs.setString('themeMode', 'dark');
                    if(!mounted) return;
                      Provider.of<ThemeModel>(context, listen: false)
                          .toggleTheme('dark');
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Icon(Icons.brightness_2,),
                        SizedBox(width: 16),
                        Text('Dark mode',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        Spacer(),
                        Radio(
                          fillColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                          overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                          activeColor: Colors.blue,
                          value: 'dark',
                          groupValue: isDarkMode,
                          onChanged: (value) {},
                          toggleable: false,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async{
                    final Future<SharedPreferences> asynPrefs = SharedPreferences.getInstance();
                    final SharedPreferences prefs = await asynPrefs;
                    prefs.setString('themeMode', 'light');
                    if(!mounted) return;
                      Provider.of<ThemeModel>(context, listen: false)
                          .toggleTheme('light');
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Icon(Icons.brightness_5),
                        SizedBox(width: 16),
                        Text('Light mode',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        Spacer(),
                        Radio(
                          fillColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                          overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                          activeColor: Colors.blue,
                          value: 'light',
                          groupValue: isDarkMode,
                          onChanged: (value) {},
                          toggleable: false,
                        ),
                      ],
                    ),
                  ),
                ),
                                GestureDetector(
                  onTap: () async{
                                        final Future<SharedPreferences> asynPrefs = SharedPreferences.getInstance();
                    final SharedPreferences prefs = await asynPrefs;
                    prefs.setString('themeMode', 'system');
                    if(!mounted) return;
                      Provider.of<ThemeModel>(context, listen: false)
                          .toggleTheme('system');
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Icon(Icons.brightness_4),
                        SizedBox(width: 16),
                        Text('Use system theme',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        Spacer(),
                        Radio(
                          fillColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                          overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                          activeColor: Colors.blue,
                          value: 'system',
                          groupValue: isDarkMode,
                          onChanged: (value) {},
                          toggleable: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
