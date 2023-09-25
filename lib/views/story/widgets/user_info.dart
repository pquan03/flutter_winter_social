import 'package:flutter/material.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/utils/time_ago_custom.dart';

class UserInfo extends StatelessWidget {
  final UserPost user;
  final String createdAt;

  const UserInfo({super.key, required this.user, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.grey[300],
          backgroundImage: NetworkImage(user.avatar!),
        ),
        const SizedBox(width: 10.0),
        Text(
          user.username!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 10.0),
        Text(convertTimeAgo(createdAt),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.0,
            )),
      ],
    );
  }
}
