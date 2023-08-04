

import 'package:flutter/material.dart';
import 'package:insta_node_app/models/auth.dart';

class AuthProvider extends ChangeNotifier {
  Auth _auth = Auth();

  Auth get auth => _auth;

  void setAuth(Auth auth) {
    _auth = auth;
    notifyListeners();
  }

} 