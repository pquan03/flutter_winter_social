import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insta_node_app/common_widgets/button_widget.dart';
import 'package:insta_node_app/models/user.dart' as model;
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/screens/screens/settings.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<AuthProvider>(context).auth.user!;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(user.username!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          actions: [
            GestureDetector(
                onTap: () {},
                child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.add_box_outlined))),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.menu),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user.avatar!),
                      ),
                      const SizedBox(height: 8),
                      Text(user.fullname!,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        StartColumnItem(0, 'Posts'),
                        Spacer(),
                        StartColumnItem(user.followers!.length, 'Followers'),
                        Spacer(),
                        StartColumnItem(user.following!.length, 'Following'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(user.mobile!, style: TextStyle(fontSize: 18, color: Colors.white),),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: HexColor('#121212'),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text('Edit Profile',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: GestureDetector(
                      onTap:  () {
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: HexColor('#121212'),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text('Share profile',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Column StartColumnItem(int num, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(num.toString(),
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 8),
        Text(title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }
}
