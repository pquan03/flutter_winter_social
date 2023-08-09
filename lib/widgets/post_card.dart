import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/recources/post_api.dart';
import 'package:insta_node_app/screens/screens/other_profile.dart';
import 'package:insta_node_app/screens/screens/profile.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/widgets/comment_modal.dart';
import 'package:insta_node_app/widgets/like_animation.dart';
import 'package:insta_node_app/widgets/post_modal.dart';
import 'package:intl/intl.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.post.userPost!.sId! == widget.auth.user!.sId!) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                              userId: widget.auth.user!.sId!,
                              token: widget.auth.accessToken!)));
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => OtherProfileScreen(
                              userId: widget.post.userPost!.sId!,
                              token: widget.auth.accessToken!)));
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.post.userPost!.avatar!),
                          radius: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            widget.post.userPost!.username!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
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
                    ))
              ],
            ),
          )
          // Image section
          ,
          GestureDetector(
            onDoubleTap: () {
              handleLikePost(widget.auth.user!.sId!);
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
                        await Future.delayed(Duration(seconds: 1), () {
                          if (mounted) {
                            setState(() {
                              _isShowPageImage = false;
                            });
                          }
                        });
                      },
                      enableInfiniteScroll: false,
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      viewportFraction: 1),
                  items: widget.post.images!.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ImageHelper.loadImageNetWork(i,
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
                isAnimating:
                    widget.post.likes!.contains(widget.auth.user!.sId), // [1
                smallLike: true,
                child: IconButton(
                    onPressed: () => handleLikePost(widget.auth.user!.sId!),
                    icon: widget.post.likes!.contains(widget.auth.user!.sId)
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
                        postId: widget.post.sId!,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.comment_outlined,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send_outlined,
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
                          )
                        : Icon(
                            Icons.bookmark_border_outlined,
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
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyText1!.color),
                      children: [
                        TextSpan(
                          text: widget.post.userPost!.username!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          style: TextStyle(fontWeight: FontWeight.normal),
                          text: ' ${widget.post.content}',
                        ),
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
                    style: TextStyle( fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                    DateFormat.yMMMd()
                        .format(DateTime.parse(widget.post.createdAt!)),
                    style: TextStyle(fontSize: 16))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
