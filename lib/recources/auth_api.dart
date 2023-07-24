import 'dart:convert';

import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/recources/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  final Repository _repository = Repository();
  Future<dynamic> loginUser(String account, String passowrd) async {
    try {
      final res = await _repository.postApi(
          'login',
          {
            'account': account,
            'password': passowrd,
          },
          null);
      final auth = Auth.fromJson(res);
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.setString('accessToken', auth.accessToken!);
      prefs.setString('refreshToken', auth.refreshToken!);
      return auth;
    } catch (err) {
      return 'Error';
    }
  }

  Future<dynamic> registerUser(
      String fullname, String username, String email, String password) async {
    try {
      final res = await _repository.postApi(
          'register',
          {
            'email': email,
            'password': password,
            'fullname': fullname,
            'username': username,
          },
          null);
      return res['msg'] is String ? res['msg'] : res['msg'][0];
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> checkUserName(String username) async {
    String res = 'Something went wrong';
    try {
      final response = await _repository.postApi(
          'check_user_name',
          {
            'username': username,
          },
          null);
      res = response['msg'];
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> checkEmail(String email) async {
    String res = 'Something went wrong';
    try {
      final response = await _repository.postApi(
          'check_email',
          {
            'email': email,
          },
          null);
      res = response['msg'];
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<dynamic> refreshTokenUser(String refreshToken) async {
    try {
      final res = await _repository.getApi('refresh_token', refreshToken);
      final auth = Auth.fromJson(res);
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.setString('accessToken', auth.accessToken!);
      prefs.setString('refreshToken', auth.refreshToken!);
      return auth;
    } catch (err) {
      return err.toString();
    }
  }

  Future<dynamic> logoutUser() async {
    try {
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.remove('accessToken');
      prefs.remove('refreshToken');
      return 'Success';
    } catch (err) {
      return err.toString();
    }
  }

  Future<dynamic> forgotPassword(String account) async {
    try {
      final res = await _repository.postApi(
          'forgot_password',
          {
            'account': account,
          },
          null);
      if (res['msg'] != null) {
        return res['msg'];
      } else {
        return res;
      }
    } catch (err) {
      return err.toString();
    }
  }

    Future<dynamic> resetPassword(String id, String password) async {
    try {
      final res = await _repository.postApi(
          'reset_password',
          {
            '_id': id,
            'password': password,
          },
          null);
      return res['msg'];
    } catch (err) {
      return err.toString();
    }
  }
}
