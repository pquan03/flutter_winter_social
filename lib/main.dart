import 'package:flutter/material.dart';
import 'package:insta_node_app/constants/themes.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/providers/theme.dart';
import 'package:insta_node_app/screens/splash.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ThemeModel()),
  ], child: const MyApp()));
}

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
        themeMode: Provider.of<ThemeModel>(context).theme == 'system' ? ThemeMode.system : 
          Provider.of<ThemeModel>(context).theme == 'light' ? ThemeMode.light : ThemeMode.dark
        ,
        theme: ThemeClass
            .lightTheme, // applies this theme if the device theme is light mode
        darkTheme: ThemeClass
            .darkTheme, // applies this theme if the device theme is dark mode,
        home: const SplashPage());
  }
}
