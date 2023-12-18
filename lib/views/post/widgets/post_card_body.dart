import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insta_node_app/utils/helpers/image_helper.dart';
import 'package:insta_node_app/common_widgets/like_animation.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/views/post/widgets/post_card_actions.dart';

class PostCardBody extends StatefulWidget {
  final Post post;
  final Function handleLikePost;
  final Function handleSavePost;
  const PostCardBody({
    super.key,
    required this.post,
    required this.handleLikePost,
    required this.handleSavePost,
  });

  @override
  State<PostCardBody> createState() => _PostCardBodyState();
}

class _PostCardBodyState extends State<PostCardBody> {
  final CarouselController _carouselController = CarouselController();
  bool _isAnimating = false;
  int _currentImage = 1;
  bool _isShowPageImage = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onDoubleTap: () {
            widget.handleLikePost();
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
                      return Container(
                        color: Colors.black,
                        child: ImageHelper.loadImageNetWork(i,
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).height * 0.7,
                            fit: BoxFit.cover),
                      );
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
        PostCardActions(
            post: widget.post,
            handleLikePost: widget.handleLikePost,
            currentImage: _currentImage,
            handleSavePost: widget.handleSavePost)
      ],
    );
  }
}
