import 'package:flutter/material.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/screens/screens/splash.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider (
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          primaryColor: Colors.white,
          primaryIconTheme: const IconThemeData(color: Colors.black),
          primaryTextTheme: const TextTheme(
            headlineMedium: TextStyle(color: Colors.black, fontFamily: "Roboto"),
          ),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(color: Colors.black),
          ),
        ),
        darkTheme: ThemeData(
          primaryColor: Colors.black,
          primaryIconTheme: const IconThemeData(color: Colors.white),
          primaryTextTheme: const TextTheme(
            headlineMedium: TextStyle(color: Colors.white, fontFamily: "Roboto"),
          ),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(color: Colors.white),
          ),
        ),
        home: const SplashPage()
      ),
    );
  }
}

