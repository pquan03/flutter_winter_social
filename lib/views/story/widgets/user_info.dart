import 'package:flutter/material.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class UserInfo extends StatelessWidget {
  final UserPost user;
  final String storyId;
  final String createdAt;
  final Function(String, String) handleDeleteStory;

  const UserInfo(
      {super.key,
      required this.user,
      required this.createdAt,
      required this.storyId,
      required this.handleDeleteStory});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context).auth;
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
        Text(THelperFunctions.convertTimeAgo(createdAt),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.0,
            )),
        Spacer(),
        if (user.username == 'Your Story' ||
            user.username == auth.user!.username)
          IconButton(
            onPressed: () {
              // show menu
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(0),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            onTap: () async {
                              Navigator.pop(context);
                              // delete post
                              handleDeleteStory(storyId, auth.accessToken!);
                            },
                            leading: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            title: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
            icon: const Icon(
              Icons.more_horiz,
              size: 30.0,
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}
