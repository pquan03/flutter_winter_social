import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/like_animation.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/views/comment/comment_modal_post.dart';
import 'package:insta_node_app/views/post/widgets/post_send_mess_modal.dart';
import 'package:provider/provider.dart';

class PostCardActions extends StatefulWidget {
  final Post post;
  final Function handleLikePost;
  final Function handleSavePost;
  final int currentImage;
  const PostCardActions(
      {super.key,
      required this.post,
      required this.handleLikePost,
      required this.currentImage,
      required this.handleSavePost});

  @override
  State<PostCardActions> createState() => _PostCardActionsState();
}

class _PostCardActionsState extends State<PostCardActions> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).auth.user!;
    return Row(
      children: [
        LikeAnimation(
          isAnimating: widget.post.likes!.contains(currentUser.sId), // [1
          smallLike: true,
          child: IconButton(
              onPressed: () => widget.handleLikePost(),
              icon: widget.post.likes!.contains(currentUser.sId)
                  ? Icon(
                      Icons.favorite,
                      color: Colors.pinkAccent,
                    )
                  : // [2
                  Icon(
                      Icons.favorite_border_outlined,
                    )),
        ),
        IconButton(
            onPressed: () {
              showModalBottomSheetCustom(
                context,
                CommentModal(
                  ratio: 1,
                  post: widget.post,
                ),
              );
            },
            icon: Icon(
              Icons.comment_outlined,
            )),
        IconButton(
            onPressed: () {
              showModalBottomSheetCustom(
                  context,
                  PostSendMessModal(
                    post: widget.post,
                  ));
            },
            icon: Icon(
              Icons.send_outlined,
            )),
        widget.post.images!.length > 1
            ? Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.post.images!.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: widget.currentImage == index + 1
                                ? Colors.orange
                                : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    )),
              )
            : Spacer(),
        LikeAnimation(
          isAnimating: currentUser.saved!.contains(widget.post.sId), // [1
          smallLike: true,
          child: IconButton(
              onPressed: () => widget.handleSavePost(),
              icon: currentUser.saved!.contains(widget.post.sId)
                  ? Icon(
                      Icons.bookmark,
                    )
                  : Icon(
                      Icons.bookmark_border_outlined,
                    )),
        ),
      ],
    );
  }
}
