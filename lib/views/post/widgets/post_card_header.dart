import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/circle_avatar.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/views/profile/screens/other_profile.dart';
import 'package:insta_node_app/views/profile/screens/profile.dart';
import 'package:provider/provider.dart';

import 'post_modal.dart';

class PostCardHeader extends StatefulWidget {
  final Post post;
  final Function deletePost;
  final Function savePost;
  const PostCardHeader(
      {super.key,
      required this.post,
      required this.deletePost,
      required this.savePost});

  @override
  State<PostCardHeader> createState() => _PostCardHeaderState();
}

class _PostCardHeaderState extends State<PostCardHeader> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).auth.user!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
          .copyWith(right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.post.userPost!.sId! == currentUser.sId!) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ProfileScreen()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => OtherProfileScreen(
                          userId: widget.post.userPost!.sId!,
                        )));
              }
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  CircleAvatarWidget(
                      imageUrl: widget.post.userPost!.avatar, radius: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      widget.post.userPost!.username!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                showModalBottomSheetCustom(
                  context,
                  PostModal(
                    postId: widget.post.sId!,
                    postUserId: widget.post.userPost!.sId!,
                    deletePost: widget.deletePost,
                    savePost: widget.savePost,
                    isSaved: currentUser.saved!.contains(widget.post.sId!),
                  ),
                );
              },
              icon: Icon(
                Icons.more_vert,
              ))
        ],
      ),
    );
  }
}
