import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/bloc/comment_bloc/comment_event.dart';
import 'package:insta_node_app/bloc/comment_bloc/comment_bloc.dart';
import 'package:insta_node_app/bloc/comment_bloc/comment_state.dart';
import 'package:insta_node_app/constants/size.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/notifi_api.dart';
import 'package:insta_node_app/views/comment/comment_card.dart';
import 'package:provider/provider.dart';

class CommentModal extends StatefulWidget {
  final Post post;
  final double ratio;
  const CommentModal({
    super.key,
    required this.ratio,
    required this.post,
  });

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  late TextEditingController _commentController;
  final FocusNode _commentFocus = FocusNode();
  double _ratio = 0.5;
  dynamic tag;
  bool _isShowReply = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void handleClickReply(var data) {
    _commentFocus.requestFocus();
    setState(() {
      tag = data;
    });
  }

  void handleChangeShowReply(bool value) {
    setState(() {
      _isShowReply = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    final accessToken = Provider.of<AuthProvider>(context).auth.accessToken!;
    return BlocProvider<CommentBloc>(
      create: (context) => CommentBloc()
        ..add(CommentEventFetch(
            postId: widget.post.sId!, token: accessToken, type: 'post')),
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: SizedBox(
          height: MediaQuery.of(context).size.height *
              (widget.ratio == 1 ? widget.ratio : _ratio),
          child: Column(
            children: <Widget>[
              Text(
                'Comments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                  width: double.infinity,
                  height: 1,
                  color: Theme.of(context).colorScheme.secondary),
              BlocBuilder<CommentBloc, CommentState>(
                  builder: (context, commentState) {
                if (commentState is CommentStateLoading) {
                  return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      )));
                } else if (commentState is CommentStateSuccess) {
                  return Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: commentState.listComment.length,
                            itemBuilder: (context, index) {
                              return CommentCard(
                                isShowReply: _isShowReply,
                                comment: commentState.listComment[index],
                                handleClickReply: handleClickReply,
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            left: 16,
                            right: 16,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(user.avatar!),
                                radius: 20,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                  child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: TSizes.defaultSpace),
                                child: TextField(
                                  onTap: () {
                                    if (widget.ratio == 1) {
                                    } else {
                                      setState(() {
                                        _ratio = 1;
                                      });
                                    }
                                  },
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        tag = null;
                                      });
                                    }
                                  },
                                  controller: _commentController,
                                  focusNode: _commentFocus,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                      prefix: tag != null
                                          ? Container(
                                              color:
                                                  Colors.blue.withOpacity(.5),
                                              margin: const EdgeInsets.only(
                                                  right: 8),
                                              child: Text(
                                                '${tag.user.username}',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontSize: 16),
                                              ),
                                            )
                                          : null,
                                      hintText: 'Add a comment...',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                      border: InputBorder.none),
                                ),
                              )),
                              IconButton(
                                onPressed: () async {
                                  if (tag != null &&
                                      _commentController.text.isNotEmpty) {
                                    context.read<CommentBloc>().add(
                                        CreateReplyEvent(
                                            commentRootId:
                                                tag.commentRootId ?? tag.sId,
                                            token: accessToken,
                                            postId: widget.post.sId!,
                                            content: _commentController.text,
                                            tag: tag.user));
                                    setState(() {
                                      _commentController.text = '';
                                      tag = null;
                                      _isShowReply = true;
                                    });
                                  } else {
                                    final msg = {
                                      'text': 'has commented on your post',
                                      'recipients': [
                                        widget.post.userPost!.sId!
                                      ],
                                      'url': widget.post.sId,
                                      'content': '',
                                      'image': widget.post.images![0],
                                      'user': {
                                        'sId': user.sId,
                                        'username': user.username,
                                        'avatar': user.avatar,
                                      },
                                    };
                                    await NotifiApi()
                                        .createNotification(msg, accessToken);
                                    if (!mounted) return;
                                    context.read<CommentBloc>().add(
                                        CreateCommentEvent(
                                            type: 'post',
                                            token: accessToken,
                                            postId: widget.post.sId!,
                                            content: _commentController.text));
                                    _commentController.text = '';
                                  }
                                },
                                icon: Icon(
                                  Icons.send_outlined,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Center(
                  child: Text('Error!'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
