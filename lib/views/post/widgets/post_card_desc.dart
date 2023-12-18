import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:insta_node_app/views/comment/comment_modal_post.dart';
import 'package:insta_node_app/views/post/screens/likes_post.dart';

class PostCardDesc extends StatelessWidget {
  final Post post;
  const PostCardDesc({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.likes!.isNotEmpty)
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LikesPostScreen(
                        likes: post.likes!,
                      ))),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '${post.likes!.length} likes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          RichText(
            text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                children: [
                  TextSpan(
                    text: post.userPost!.username!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    text: ' ${post.content}',
                  ),
                ]),
          ),
          // View all comment section
          const SizedBox(
            height: 4,
          ),
          if (post.comments!.isNotEmpty)
            GestureDetector(
              onTap: () {
                showModalBottomSheetCustom(
                  context,
                  CommentModal(
                    ratio: 0.5,
                    post: post,
                  ),
                );
              },
              child: Text(
                'View all ${post.comments!.length} comments',
                style: TextStyle(fontSize: 16),
              ),
            ),
          const SizedBox(
            height: 4,
          ),
          Text(THelperFunctions.convertTimeAgo(post.createdAt!),
              style: TextStyle(fontSize: 16))
        ],
      ),
    );
  }
}
