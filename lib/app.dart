import 'package:flutter/material.dart';
import 'package:insta_node_app/utils/theme/theme.dart';
import 'package:insta_node_app/views/auth/screens/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeAnimationCurve: Curves.easeInOut,
        themeAnimationDuration: const Duration(milliseconds: 500),
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        home: SplashPage());
  }
}
