import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/button_widget.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/constants/asset_helper.dart';
import 'package:insta_node_app/models/user.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/auth_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/views/auth/screens/login.dart';
import 'package:insta_node_app/views/auth/screens/main_app.dart';
import 'package:insta_node_app/views/auth/screens/signup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggedInScreen extends StatefulWidget {
  const LoggedInScreen({super.key});

  @override
  State<LoggedInScreen> createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen> {
  final List<UserLoginned> _listUserLogin = [];

  @override
  void initState() {
    super.initState();
    _getListUserLogined();
  }

  void _getListUserLogined() async {
    final Future<SharedPreferences> asyncPrefs =
        SharedPreferences.getInstance();
    final SharedPreferences prefs = await asyncPrefs;
    List<String> decodeUserLogginedString =
        prefs.getStringList('listUserLogin') ?? [];
    List<UserLoginned> decodeUserLoggined = decodeUserLogginedString
        .map((e) => UserLoginned.fromJson(jsonDecode(e)))
        .toList();
    setState(() {
      _listUserLogin.addAll(decodeUserLoggined);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [
              Color(0xFF833AB4).withOpacity(.2),
              Color(0xFFFD1D1D).withOpacity(.1),
              Color(0xFFFCAF45).withOpacity(.2),
            ])),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.12),
                alignment: Alignment.bottomCenter,
                child: ImageHelper.loadImageAsset(AssetHelper.icLogo,
                    height: 60, width: 60)),
            Expanded(
              flex: 2,
              child: _listUserLogin.isEmpty
                  ? SizedBox.shrink()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _listUserLogin.length,
                      itemBuilder: ((context, index) {
                        final user = _listUserLogin[index];
                        return InkWell(
                          onTap: () async {
                            final res = await AuthApi()
                                .refreshTokenUser(user.refreshToken, index);
                            if (res is String) {
                              if (!mounted) return;
                              showSnackBar(context, 'Error', res);
                              return;
                            }
                            if (!mounted) return;
                            Provider.of<AuthProvider>(context, listen: false)
                                .setAuth(res);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => const MainAppScreen()),
                                (route) => false);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              title: Text(
                                user.username,
                                style: TextStyle(fontSize: 18),
                              ),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(user.avatar),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: const Text(
                'Login with another account',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
              child: Column(
                children: [
                  ButtonWidget(
                    text: 'Create new account',
                    textColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                    },
                    borderColor: Colors.blue,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '☂ Winter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
