import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insta_node_app/constants/size.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:insta_node_app/utils/helpers/image_helper.dart';
import 'package:insta_node_app/utils/helpers/asset_helper.dart';
import 'package:insta_node_app/models/user.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/auth_api.dart';
import 'package:insta_node_app/views/auth/screens/login.dart';
import 'package:insta_node_app/views/navigation_view.dart';
import 'package:insta_node_app/views/auth/screens/signup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/dimension.dart';

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

  void _deleteUserLoggined(String username) async {
    final Future<SharedPreferences> asyncPrefs =
        SharedPreferences.getInstance();
    final SharedPreferences prefs = await asyncPrefs;
    List<String> decodeUserLogginedString =
        prefs.getStringList('listUserLogin') ?? [];
    List<UserLoginned> decodeUserLoggined = decodeUserLogginedString
        .map((e) => UserLoginned.fromJson(jsonDecode(e)))
        .toList();
    setState(() {
      _listUserLogin.removeWhere((element) => element.username == username);
    });
    decodeUserLoggined.removeWhere((element) => element.username == username);
    if (decodeUserLoggined.isEmpty) {
      if (!mounted) return;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
    List<String> encodeUserLogginedString =
        decodeUserLoggined.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList('listUserLogin', encodeUserLogginedString);
  }

  void _login(String refreshToken, int index) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    // delay 1s to show loading dialog
    await Future.delayed(const Duration(seconds: 1), () {});
    final res = await AuthApi().refreshTokenUser(refreshToken, index);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
      return;
    }
    if (!mounted) return;
    Provider.of<AuthProvider>(context, listen: false).setAuth(res);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainAppScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
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
                          onTap: () => _login(user.refreshToken, index),
                          child: Container(
                            margin: const EdgeInsets.only(
                                bottom: Dimensions.dPaddingSmall),
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
                                radius: 20,
                                backgroundImage: NetworkImage(user.avatar),
                              ),
                              trailing: IconButton(
                                  onPressed: () =>
                                      _deleteUserLoggined(user.username),
                                  icon: Icon(
                                    Icons.delete,
                                  )),
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
              child: Text(
                'Login with another account',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen())),
                        child: const Text("Create new account")),
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
