import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/bloc/comment_bloc/comment_event.dart';
import 'package:insta_node_app/bloc/comment_bloc/comment_bloc.dart';
import 'package:insta_node_app/bloc/comment_bloc/comment_state.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentModal extends StatefulWidget {
  final String postId;
  final double ratio;
  const CommentModal({super.key, required this.postId, required this.ratio});

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  final TextEditingController _commentController = TextEditingController();
  double _ratio = 0.5;
  dynamic tag;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleClickReply(var data) {
    setState(() {
      tag = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    final accessToken = Provider.of<AuthProvider>(context).auth.accessToken!;
    return BlocProvider<CommentBloc>(
      create: (context) =>
          CommentBloc()..add(CommentEventFetch(postId: widget.postId)),
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
        child: SizedBox(
          height: MediaQuery.of(context).size.height *
              (widget.ratio == 1 ? widget.ratio : _ratio),
          child: Column(
            children: <Widget>[
              Text(
                'Comments',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(width: double.infinity, height: 1, color: Colors.white),
              BlocBuilder<CommentBloc, CommentState>(
                  builder: (context, commentState) {
                if (commentState is CommentStateLoading) {
                  return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                          child:
                              CircularProgressIndicator(color: Colors.white)));
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                                  autofocus: false,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
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
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            )
                                          : null,
                                      hintText: 'Add a comment...',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              )),
                              IconButton(
                                onPressed: () {
                                  if (tag != null) {
                                    context.read<CommentBloc>().add(
                                        CreateReplyEvent(
                                            commentRootId:
                                                tag.commentRootId ?? tag.sId,
                                            token: accessToken,
                                            postId: widget.postId,
                                            content: _commentController.text,
                                            tag: tag.user));
                                    _commentController.text = '';
                                    setState(() {
                                      tag = null;
                                    });
                                  } else {
                                    context.read<CommentBloc>().add(
                                        CreateCommentEvent(
                                            token: accessToken,
                                            postId: widget.postId,
                                            content: _commentController.text));
                                    _commentController.text = '';
                                  }
                                },
                                icon: Icon(
                                  Icons.send_outlined,
                                  color: Colors.white,
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
