import 'package:flutter/material.dart';
import 'package:insta_node_app/models/comment.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/comment_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/common_widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final Function handleClickReply;
  const CommentCard({super.key, required this.comment, required this.handleClickReply});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool _isLoadReply = false;
  bool _isShowReply = false;
  int _countReply = 0;

  void handleLikeComment(String uId, String token) async {
    if (widget.comment.likes!.contains(uId)) {
      final res = await CommentApi().unLikeComment(widget.comment.sId!, token);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          widget.comment.likes!.remove(uId);
        });
      }
    } else {
      final res = await CommentApi().likeComment(widget.comment.sId!, token);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          widget.comment.likes!.add(uId);
        });
      }
    }
  }

  void handleLoadReplyComment() async {
    setState(() {
      _isLoadReply = true;
    });
      await Future.delayed(Duration(milliseconds: 500));
      if(widget.comment.reply!.length  - _countReply <= 4) {
        setState(() {
          _countReply += widget.comment.reply!.length - _countReply;
          _isShowReply = true;
          _isLoadReply = false;
        });
      } else {
      setState(() {
        _countReply += 4;
        _isShowReply = true;
        _isLoadReply = false;
      });
      }
    }
  


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    final accessToken = Provider.of<AuthProvider>(context).auth.accessToken!;
    return Padding(
      padding: widget.comment.tag == null ? const EdgeInsets.all(16) : const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.comment.user!.avatar!),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            widget.comment.user!.username!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          widget.comment.tag != null ? 
                          RichText(
                            text: TextSpan(
                              text: '@${widget.comment.tag!.username!} ',
                              style: TextStyle(color: Colors.blue),
                              children: [
                                TextSpan(
                                  text: widget.comment.content!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.secondary,
                                  )
                                )
                              ]
                            ),
                          )
                          :
                          Text(
                            widget.comment.content!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    LikeAnimation(
                      isAnimating:
                          widget.comment.likes!.contains(user.sId), // [1
                      smallLike: true,
                      child: GestureDetector(
                          onTap: () =>
                              handleLikeComment(user.sId!, accessToken),
                          child: widget.comment.likes!.contains(user.sId)
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.pinkAccent,
                                )
                              : // [2
                              Icon(
                                  Icons.favorite_border_outlined,
                                )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      DateFormat.yMMMd()
                          .format(DateTime.parse(widget.comment.createdAt!)),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '${widget.comment.likes!.length} like',
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () => widget.handleClickReply(widget.comment),
                      child: Text(
                        'Reply',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: _isShowReply == true && widget.comment.reply!.isNotEmpty
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: Column(
                          children: [
                            ...(widget.comment.reply!).sublist(0, _countReply).map((e) => CommentCard(comment: e, handleClickReply: widget.handleClickReply,))
                          ],
                        ),
                        secondChild: Container(),
                      ),
                  widget.comment.reply!.length - _countReply > 0 && widget.comment.tag == null 
                    ? GestureDetector(
                        onTap: handleLoadReplyComment,
                        child: Row(children: <Widget>[
                          Container(
                            width: 20,
                            height: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                              _isLoadReply
                                  ? 'Loading...'
                                  : 'View more replies (${widget.comment.reply!.length - _countReply})',
                              style: TextStyle(color: Colors.grey)),
                        ]),
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
