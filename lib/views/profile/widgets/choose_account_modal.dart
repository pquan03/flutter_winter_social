import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insta_node_app/models/user.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/auth_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/views/auth/screens/main_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseAccountModalWidget extends StatefulWidget {
  const ChooseAccountModalWidget({super.key});

  @override
  State<ChooseAccountModalWidget> createState() =>
      _ChooseAccountModalWidgetState();
}

class _ChooseAccountModalWidgetState extends State<ChooseAccountModalWidget> {
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Wrap(
        children: [
          _listUserLogin.isEmpty
              ? SizedBox.shrink()
              : buildListUserLogiginned(),
          const Divider(),
          buildAddAccountTile(),
          const Divider(),
          buildSwitchAccountTile(),
        ],
      ),
    );
  }

  Widget buildListUserLogiginned() {
    return Column(
      children: _listUserLogin
          .map((e) => buildAccountTile(e, _listUserLogin.indexOf(e)))
          .toList(),
    );
  }

  Widget buildAccountTile(UserLoginned user, index) {
    return InkWell(
      onTap: () async {
        final res = await AuthApi().refreshTokenUser(user.refreshToken, index);
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
      },
      child: Container(
        color: Colors.transparent,
        child: ListTile(
          title: Text(
            user.username,
            style: TextStyle(fontSize: 18),
          ),
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(user.avatar),
          ),
        ),
      ),
    );
  }

  Widget buildAddAccountTile() {
    return ListTile(
      leading: const Icon(Icons.add),
      title: const Text('Add account'),
      onTap: () {},
    );
  }

  Widget buildSwitchAccountTile() {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Switch account'),
      onTap: () {},
    );
  }
}
