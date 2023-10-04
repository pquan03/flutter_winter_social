import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/like_animation.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/notifi_api.dart';
import 'package:insta_node_app/recources/reel_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/views/reel/widgets/reel_card_info.dart';
import 'package:insta_node_app/views/reel/widgets/reel_card_sidebar.dart';
import 'package:insta_node_app/views/reel/widgets/reel_modal.dart';
import 'package:insta_node_app/views/reel/widgets/video_card.dart';
import 'package:provider/provider.dart';

class ReelCardWidget extends StatefulWidget {
  final Reel reel;
  final Function(String reelId) deleteReel;
  const ReelCardWidget({
    super.key,
    required this.reel,
    required this.deleteReel,
  });

  @override
  State<ReelCardWidget> createState() => _ReelCardWidgetState();
}

class _ReelCardWidgetState extends State<ReelCardWidget> {
  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).auth.user;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          GestureDetector(
            onLongPress: () {
              showModalBottomSheetCustom(
                  context,
                  ReelModal(
                    reelId: widget.reel.sId!,
                    deleteReel: (String reelId) {},
                    reelUserId: widget.reel.user!.sId!,
                    savePost: handleSaveReel,
                    isSaved: user!.saved!.contains(widget.reel.sId!),
                  ));
            },
            onDoubleTap: () {
              setState(() {
                _isAnimating = true;
              });
              handleLikeReel();
            },
            child: VideoCardWidget(
              backgroundUrl: widget.reel.backgroundUrl,
              videoUrl: widget.reel.videoUrl,
            ),
          ),
          Positioned(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: _isAnimating ? 1 : 0,
              child: Center(
                child: LikeAnimation(
                  isAnimating: _isAnimating,
                  duration: const Duration(
                    milliseconds: 700,
                  ),
                  onEnd: () {
                    setState(() {
                      _isAnimating = false;
                    });
                  },
                  child: Icon(
                    Icons.favorite,
                    size: 100,
                    shadows: const [
                      BoxShadow(
                          color: Colors.pinkAccent,
                          blurRadius: 10,
                          spreadRadius: 5)
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              right: 10,
              child: ReelCardSideBarWidget(
                  handleDelelteReel: () => widget.deleteReel(widget.reel.sId!),
                  handleSaveReel: handleSaveReel,
                  handleLikeReel: handleLikeReel,
                  reel: widget.reel)),
          Positioned(
              left: 10,
              right: 70,
              bottom: 20,
              child: ReelCardInforWidget(
                reel: widget.reel,
              ))
        ],
      ),
    );
  }

  void handleLikeReel() async {
    print('add');
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken;
    final user = Provider.of<AuthProvider>(context, listen: false).auth.user;
    if (widget.reel.likes!.contains(user!.sId)) {
      final res = await ReelApi().unLikeReel(widget.reel.sId!, token!);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          widget.reel.likes!.remove(user.sId);
        });
        if (widget.reel.user!.sId! != user.sId!) {
          await NotifiApi()
              .deleteNotification(user.sId!, widget.reel.sId!, token);
        }
      }
    } else {
      final res = await ReelApi().likeReel(widget.reel.sId!, token!);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          widget.reel.likes!.add(user.sId!);
        });
        if (widget.reel.user!.sId! != user.sId!) {
          final msg = {
            'text': 'like your post',
            'recipients': [widget.reel.user!.sId!],
            'url': widget.reel.sId,
            'content': widget.reel.content,
            'type': 'reel',
            'image': widget.reel.backgroundUrl,
            'user': {
              'sId': user.sId,
              'username': user.username,
              'avatar': user.avatar,
            },
          };
          await NotifiApi().createNotification(msg, token);
        }
      }
    }
  }

  void handleSaveReel() async {
    final auth = Provider.of<AuthProvider>(context, listen: false).auth;
    if (auth.user!.saved!.contains(widget.reel.sId)) {
      final res =
          await ReelApi().unSaveReel(widget.reel.sId!, auth.accessToken!);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          auth.user!.saved!.remove(widget.reel.sId);
        });
      }
    } else {
      final res = await ReelApi().saveReel(widget.reel.sId!, auth.accessToken!);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          auth.user!.saved!.add(widget.reel.sId!);
        });
      }
    }
  }
}
