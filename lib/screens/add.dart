import 'package:flutter/material.dart';
import 'package:insta_node_app/screens/add_post.dart';
import 'package:insta_node_app/screens/add_reel.dart';
import 'package:insta_node_app/widgets/button_add_post.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final PageController _pageController = PageController();


  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
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
              children: const [
                AddPostScreen(),
                AddReelScreen(),
              ],
            ),
          ),
          AddPostButton(handleChangeType: navigationTapped)
        ],
      ),
    );
  }
}