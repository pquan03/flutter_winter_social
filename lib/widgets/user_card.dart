import 'package:flutter/material.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/screens/other_profile.dart';
import 'package:insta_node_app/screens/profile.dart';
import 'package:provider/provider.dart';

class UserCardWidget extends StatelessWidget {
  final UserPost user;
  const UserCardWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).auth.user!;
    final accessToken = Provider.of<AuthProvider>(context).auth.accessToken;
    return GestureDetector(
      onTap: () {
        if(user.sId! == currentUser.sId) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen(userId: user.sId!, token: accessToken!)));
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => OtherProfileScreen(userId: user.sId!, token: accessToken!)));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.avatar!),
        ),
        title: Text(user.username!, style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),
        subtitle: Text(user.fullname!, style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),),
      ),
    );
  }
}