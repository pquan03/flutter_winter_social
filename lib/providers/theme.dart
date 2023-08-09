import 'package:flutter/material.dart';



class ThemeModel extends ChangeNotifier {
  String _theme = 'system';
  String get theme => _theme;
  void toggleTheme(String theme) {
    
    _theme = theme;
    notifyListeners();
  }
}
