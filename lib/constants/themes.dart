import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeClass {
  Color lightPrimaryColor = Colors.white;
  Color darkPrimaryColor = Colors.black;
  Color secondaryColor = HexColor('#FF8B6A');
  Color accentColor = HexColor('#FFD2BB');

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Roboto',
    iconTheme: const IconThemeData(color: Colors.black),
    brightness: Brightness.light,
    indicatorColor: Colors.black,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.black),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[350],
      iconColor: Colors.grey[400],
      suffixIconColor: Colors.black,
      hintStyle: const TextStyle(color: Colors.black54),
      floatingLabelStyle: const TextStyle(color: Colors.black54),
    ),
    colorScheme: const ColorScheme.light().copyWith(
        primary: _themeClass.lightPrimaryColor,
        secondary: Colors.black,
        primaryContainer: Colors.grey[300]!.withOpacity(0.7)),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Roboto',
    iconTheme: const IconThemeData(color: Colors.white),
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    indicatorColor: Colors.white,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.white),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[800],
      iconColor: Colors.grey[800],
      suffixIconColor: Colors.black,
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeClass.darkPrimaryColor,
      secondary: Colors.white,
      primaryContainer: Colors.grey[800],
    ),
  );
}

ThemeClass _themeClass = ThemeClass();
