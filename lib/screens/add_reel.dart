import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_node_app/screens/media_gallery_reel.dart';

class AddReelScreen extends StatefulWidget {
  const AddReelScreen({super.key});

  @override
  State<AddReelScreen> createState() => _AddReelScreenState();
}

class _AddReelScreenState extends State<AddReelScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  List<Uint8List> imageList = [];
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void navigationNextTapped() {
    _pageController.jumpToPage(_currentIndex + 1);
  }

  void navigationPreTapped() {
    _pageController.jumpToPage(_currentIndex - 1);
  }

  void handleChangeImageList(List<Uint8List> newImageList) {
    setState(() {
      imageList = newImageList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: [
          MediaGalleryReelScreen(
              navigationTapped: navigationNextTapped,
              imageList: imageList,
              handleChangeImageList: handleChangeImageList),
        ],
      ),
    );
  }
}
