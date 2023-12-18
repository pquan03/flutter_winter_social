import 'package:flutter/material.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/models/user.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/notifi_api.dart';
import 'package:insta_node_app/recources/post_api.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:insta_node_app/views/post/widgets/post_card_body.dart';
import 'package:insta_node_app/views/post/widgets/post_card_desc.dart';
import 'package:insta_node_app/views/post/widgets/post_card_header.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Function(String id) deletePost;
  const PostCard({
    super.key,
    required this.post,
    required this.deletePost,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).auth.user!;
    final accessToken = Provider.of<AuthProvider>(context).auth.accessToken!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          PostCardHeader(
            post: widget.post,
            deletePost: () {
              widget.deletePost(widget.post.sId!);
            },
            savePost: () {
              handleSavePost(currentUser, accessToken);
            },
          ),
          PostCardBody(
            post: widget.post,
            handleLikePost: () => {
              handleLikePost(currentUser.sId!, accessToken, currentUser.avatar!,
                  currentUser.username!)
            },
            handleSavePost: () => {
              handleSavePost(currentUser, accessToken),
            },
          ),
          PostCardDesc(post: widget.post),
        ],
      ),
    );
  }

  void handleSavePost(User currentUser, String accessToken) async {
    if (currentUser.saved!.contains(widget.post.sId)) {
      final res = await PostApi().unSavePost(widget.post.sId!, accessToken);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          currentUser.saved!.remove(widget.post.sId);
        });
      }
    } else {
      final res = await PostApi().savePost(widget.post.sId!, accessToken);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          currentUser.saved!.add(widget.post.sId!);
        });
      }
    }
  }

  void handleLikePost(String currentUserId, String accessToken,
      String currentUserAvatar, String currentUserUsername) async {
    if (widget.post.likes!.contains(currentUserId)) {
      final res = await PostApi().unLikePost(widget.post.sId!, accessToken);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          widget.post.likes!.remove(currentUserId);
        });
        if (widget.post.userPost!.sId! != currentUserId) {
          await NotifiApi()
              .deleteNotification(currentUserId, widget.post.sId!, accessToken);
        }
      }
    } else {
      final res = await PostApi().likePost(widget.post.sId!, accessToken);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          widget.post.likes!.add(currentUserId);
        });
        if (widget.post.userPost!.sId! != currentUserId) {
          final msg = {
            'text': 'like your post',
            'recipients': [widget.post.userPost!.sId!],
            'url': widget.post.sId,
            'content': widget.post.content,
            'type': 'post',
            'image': widget.post.images![0],
            'user': {
              'sId': currentUserId,
              'username': currentUserUsername,
              'avatar': currentUserAvatar,
            },
          };
          await NotifiApi().createNotification(msg, accessToken);
        }
      }
    }
  }
}
