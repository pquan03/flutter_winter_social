import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/constants/asset_helper.dart';
import 'package:insta_node_app/models/user.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/providers/theme.dart';
import 'package:insta_node_app/recources/auth_api.dart';
import 'package:insta_node_app/views/auth/screens/loggedin_user.dart';
import 'package:insta_node_app/views/auth/screens/login.dart';
import 'package:insta_node_app/views/auth/screens/main_app.dart';
import 'package:insta_node_app/utils/socket_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    redirectToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Spacer(),
        Expanded(
          flex: 3,
          child: Center(
            child: ImageHelper.loadImageAsset(
              AssetHelper.icLogo,
              width: 100,
              height: 100,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: const [
              Text(
                'from',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                '☂ Winter',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        )
      ],
    ));
  }

  void redirectToLogin() async {
    final Future<SharedPreferences> asynPrefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await asynPrefs;
    final String? themeMode = prefs.getString('themeMode');
    // settings theme
    // prefs.clear();
    if (themeMode != null) {
      print(themeMode);
      if (!mounted) return;
      Provider.of<ThemeModel>(context, listen: false).toggleTheme(themeMode);
    }
    List<String> decodeUserLogginedString =
        prefs.getStringList('listUserLogin') ?? [];
    List<UserLoginned> decodeUserLoggined = decodeUserLogginedString
        .map((e) => UserLoginned.fromJson(jsonDecode(e)))
        .toList();
    // if have user loggined => login the first user
    if (decodeUserLoggined.isNotEmpty) {
      final currentUserLogin = decodeUserLoggined.first;
      // if not logout all => login the first user
      if (currentUserLogin.accessToken != '' &&
          currentUserLogin.refreshToken != '') {
        final res =
            await AuthApi().refreshTokenUser(currentUserLogin.refreshToken, 0);
        if (!mounted) return;
        SocketConfig.joinUser(context, res.user);
        SocketConfig.checkUserOnline(res.user);
        if (!mounted) return;
        Provider.of<AuthProvider>(context, listen: false).setAuth(res);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainAppScreen()));
      }
      // if logout all => login screen
      else {
        if (!mounted) return;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const LoggedInScreen()));
        return;
      }
    }
    // if no user loggined => login screen
    else {
      if (!mounted) return;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
      return;
    }
  }
}
