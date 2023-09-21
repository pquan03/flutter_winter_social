import 'package:flutter/material.dart';
import 'package:insta_node_app/views/add/screens/add_post/media_gallery_post.dart';
import 'package:insta_node_app/views/add/screens/add_reel/media_gallery_reel.dart';
import 'package:insta_node_app/views/add/screens/add_story/media_gallery_story.dart';
import 'package:insta_node_app/views/add/screens/widgets/button_add_post.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final PageController _pageController = PageController();
  bool _isShowTypeAdd = false;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void handleHideAddPostButton() {
    if (!mounted) return;
    setState(() {
      _isShowTypeAdd = true;
    });
    if (!mounted) return;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isShowTypeAdd = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                MediaGalleryPostScreen(
                  handleHideAddPostButton: handleHideAddPostButton,
                ),
                MediaGalleryStoryScreen(
                  handleHideAddPostButton: handleHideAddPostButton,
                ),
                MediaGalleryReelScreen(
                  handleHideAddPostButton: handleHideAddPostButton,
                ),
              ],
            ),
          ),
          Positioned(
            right: 30,
            bottom: 30,
            child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _isShowTypeAdd ? 0.0 : 1.0,
                child: AddPostButton(handleChangeType: navigationTapped)),
          )
        ],
      ),
    );
  }
}
