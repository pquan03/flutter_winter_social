import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/post_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/widgets/comment_modal.dart';
import 'package:insta_node_app/widgets/like_animation.dart';
import 'package:insta_node_app/widgets/post_modal.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Function(String id) deletePost;
  final Auth auth;
  const PostCard(
      {super.key,
      required this.post,
      required this.deletePost,
      required this.auth});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final CarouselController _carouselController = CarouselController();
  bool _isAnimating = false;
  int _currentImage = 1;
  bool _isShowPageImage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  void handleLikePost(String uId) async {
    if (widget.post.likes!.contains(uId)) {
      final res = await PostApi()
          .unLikePost(widget.post.sId!, widget.auth.accessToken!);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          widget.post.likes!.remove(uId);
        });
      }
    } else {
      final res =
          await PostApi().likePost(widget.post.sId!, widget.auth.accessToken!);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          widget.post.likes!.add(uId);
        });
      }
    }
  }

  void handleSavePost() async {
    if (widget.auth.user!.saved!.contains(widget.post.sId)) {
      final res = await PostApi()
          .unSavePost(widget.post.sId!, widget.auth.accessToken!);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          widget.auth.user!.saved!.remove(widget.post.sId);
        });
      }
    } else {
      final res =
          await PostApi().savePost(widget.post.sId!, widget.auth.accessToken!);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        setState(() {
          widget.auth.user!.saved!.add(widget.post.sId!);
        });
      }
    }
  }

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
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
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
                            savePost: handleSavePost,
                            isSaved: widget.auth.user!.saved!
                                .contains(widget.post.sId!),
                            ),
                      );
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
            onDoubleTap: () {
              handleLikePost(user.sId!);
              setState(() {
                _isAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentImage = index + 1;
                        });
                      },
                      onScrolled: (_) async {
                        setState(() {
                          _isShowPageImage = true;
                        });
                        await Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            _isShowPageImage = false;
                        });
                        });
                      },
                      enableInfiniteScroll: false,
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      viewportFraction: 1),
                  items: widget.post.images!.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ImageHelper.loadImageNetWork(i.url!,
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).height * 0.7,
                            fit: BoxFit.cover);
                      },
                    );
                  }).toList(),
                ),
                widget.post.images!.length > 1
                    ? Positioned(
                        top: 10,
                        right: 10,
                        child: AnimatedOpacity(
                          opacity: _isShowPageImage ? 1 : 0,
                          duration: Duration(seconds: 2),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$_currentImage/${widget.post.images!.length}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                AnimatedOpacity(
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
                        color: Colors.white,
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
                    onPressed: () => handleLikePost(user.sId!),
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
                    showModalBottomSheetCustom(
                      context,
                      CommentModal(
                        ratio: 1,
                        postId: widget.post.sId!,
                      ),
                    );
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
              LikeAnimation(
                isAnimating:
                    widget.auth.user!.saved!.contains(widget.post.sId), // [1
                smallLike: true,
                child: IconButton(
                    onPressed: handleSavePost,
                    icon: widget.auth.user!.saved!.contains(widget.post.sId)
                        ? Icon(
                            Icons.bookmark,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.bookmark_border_outlined,
                            color: Colors.white,
                          )),
              ),
            ],
          ),
          // Description section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '${widget.post.likes!.length} likes',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
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
                    showModalBottomSheetCustom(
                      context,
                      CommentModal(
                        ratio: 0.5,
                        postId: widget.post.sId!,
                      ),
                    );
                  },
                  child: Text(
                    'View all ${widget.post.comments!.length} comments',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                    DateFormat.yMMMd()
                        .format(DateTime.parse(widget.post.createdAt!)),
                    style: TextStyle(color: Colors.grey, fontSize: 16))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
