import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/like_animation.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/views/comment/comment_model_reel.dart';
import 'package:insta_node_app/views/reel/widgets/post_send_reel_modal.dart';
import 'package:insta_node_app/views/reel/widgets/reel_modal.dart';
import 'package:provider/provider.dart';

class ReelCardSideBarWidget extends StatelessWidget {
  const ReelCardSideBarWidget({
    super.key,
    required this.reel,
    required this.handleLikeReel,
    required this.handleSaveReel,
    required this.handleDelelteReel,
  });
  final Reel reel;
  final Function handleLikeReel;
  final Function handleSaveReel;
  final Function handleDelelteReel;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user;
    return Column(
      children: [
        Column(
          children: [
            LikeAnimation(
              isAnimating: reel.likes!.contains(user!.sId), // [1
              smallLike: true,
              child: IconButton(
                  onPressed: () => handleLikeReel(),
                  icon: reel.likes!.contains(user.sId)
                      ? Icon(
                          Icons.favorite,
                          size: 35,
                          color: Colors.pinkAccent,
                        )
                      : // [2
                      Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                          size: 35,
                        )),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              reel.likes!.length.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        SizedBox(
          height: 12,
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheetCustom(
                context, CommentModelReel(ratio: 0.5, reel: reel));
          },
          child: Column(
            children: [
              Icon(
                Icons.comment,
                color: Colors.white,
                size: 35,
              ),
              Text(
                reel.comments!.length.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Column(
          children: [
            InkWell(
              onTap: () {
                showModalBottomSheetCustom(
                    context, ReelSendMessModal(reel: reel));
              },
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 35,
              ),
            ),
            Text(
              '0',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        SizedBox(
          height: 12,
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheetCustom(
                context,
                ReelModal(
                  reelId: reel.sId!,
                  deleteReel: handleDelelteReel,
                  reelUserId: reel.user!.sId!,
                  savePost: handleSaveReel,
                  isSaved: user.saved!.contains(reel.sId!),
                ));
          },
          child: Icon(
            Icons.more_vert,
            color: Colors.white,
            size: 35,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        // animation cd circle avatar user auto rotate
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white, width: 2)),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: reel.user!.avatar != null
                ? NetworkImage(reel.user!.avatar!)
                : null,
          ),
        ),
      ],
    );
  }
}
