import 'package:flutter/material.dart';
import 'package:insta_node_app/models/post.dart';

class UserInfo extends StatelessWidget {
  final UserPost user;

  const UserInfo({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.grey[300],
          backgroundImage: NetworkImage(user.avatar!),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            user.username!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}