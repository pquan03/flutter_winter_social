

import 'package:flutter/material.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isAnimating = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.post.userPost!.avatar!),
                  radius: 16,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      widget.post.userPost!.username!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {

                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ))
              ],
            ),
          )
          // Image section
          ,
          GestureDetector(
            onDoubleTap: () async {

            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    child: Image.network(
                      widget.post.images![0].url!,
                      fit: BoxFit.cover,
                    )),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _isAnimating ? 1 : 0,
                  child: Center(
                    child: LikeAnimation(
                      isAnimating: _isAnimating,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          _isAnimating = false;
                        });
                      },
                      child: Icon(
                        Icons.favorite,
                        color: Colors.pinkAccent,
                        size: 100,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Comment section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.post.likes!.contains(user.sId), // [1
                smallLike: true,
                child: IconButton(
                    onPressed: () async {

                    },
                    icon: widget.post.likes!.contains(user.sId)
                        ? Icon(
                            Icons.favorite,
                            color: Colors.pinkAccent,
                          )
                        : // [2
                        Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.white,
                          )),
              ),
              IconButton(
                  onPressed: () {

                  },
                  icon: Icon(
                    Icons.comment_outlined,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send_outlined,
                    color: Colors.white,
                  )),
              Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark_border_outlined,
                    color: Colors.white,
                  )),
            ],
          ),
          // Description section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    '${widget.post.likes!.length} likes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      children: [
                        TextSpan(
                          text: widget.post.userPost!.username!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(children: [
                          TextSpan(
                            text: ' ${widget.post.content}',
                          ),
                        ], style: TextStyle(fontWeight: FontWeight.normal)),
                      ]),
                ),
                // View all comment section
                const SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    child: Text(
                      'View all ${widget.post.comments!.length} comments',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  child: Text(
                      DateFormat.yMMMd()
                          .format(DateTime.parse(widget.post.createdAt!)),
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                )
              ],
            ),
          ),
        ],
      ),
    );;
  }
}