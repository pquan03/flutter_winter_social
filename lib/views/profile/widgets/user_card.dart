import 'package:flutter/material.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/views/profile/screens/other_profile.dart';
import 'package:insta_node_app/views/profile/screens/profile.dart';
import 'package:provider/provider.dart';

class UserCardWidget extends StatelessWidget {
  final UserPost user;
  const UserCardWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).auth.user!;
    return GestureDetector(
      onTap: () {
        if (user.sId! == currentUser.sId) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => ProfileScreen()));
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => OtherProfileScreen(userId: user.sId!)));
      },
      child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.avatar!),
          ),
          title: Text(
            user.username!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            user.fullname!,
            style: Theme.of(context).textTheme.bodyMedium,
          )),
    );
  }
}
