import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/post_api.dart';
import 'package:insta_node_app/screens/add_post_caption.dart';
import 'package:insta_node_app/screens/media_gallery_post.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool _isLoading = false;
  final PageController _pageController = PageController();
  final TextEditingController _captionController = TextEditingController();
  List<Uint8List> imageList = [];
  int _currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
    _pageController.dispose();
  }

  void handleChangeImageList(List<Uint8List> newImageList) {
    setState(() {
      imageList = newImageList;
    });
  }

  void handleCreatePost() async {
    setState(() {
      _isLoading = true;
    });
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final res =
        await PostApi().createPost(_captionController.text, imageList, token);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      if (!mounted) return;
      Navigator.pop(context, res);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigationNextTapped() {
    _pageController.jumpToPage(_currentIndex + 1);
  }

  void navigationPreTapped() {
    _pageController.jumpToPage(_currentIndex - 1);
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
          MediaGalleryPostScreen(
              navigationTapped: navigationNextTapped,
              imageList: imageList,
              handleChangeImageList: handleChangeImageList),
          AddPostCaptionScreen(
            navigationPreTapped: navigationPreTapped,
            isLoading: _isLoading,
            handleCreatePost: handleCreatePost,
            imageList: imageList,
            controller: _captionController,
          ),
        ],
      ),
    );
  }
}
