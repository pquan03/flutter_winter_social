import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/post_api.dart';
import 'package:insta_node_app/screens/screens/preview.dart';
import 'package:insta_node_app/utils/animate_route.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  final List<File> croppedFiles;
  const AddPostScreen({super.key, required this.croppedFiles});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool _isLoading = false;
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  void handleCreatePost(String token) async {
    setState(() {
      _isLoading = true;
    });
    final res = await PostApi()
        .createPost(_captionController.text, widget.croppedFiles, token);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      if (!mounted) return;
      Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accessToken = Provider.of<AuthProvider>(context).auth.accessToken!;
    return LayoutScreen(
      title: 'New Post',
      action: [
        _isLoading
            ? Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
            : IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 30,
                  color: Colors.blue,
                ),
                onPressed: () => handleCreatePost(accessToken),
              )
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade700,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                  createRoute(PreviewScreen(images: widget.croppedFiles))),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ImageHelper.loadImageFile(widget.croppedFiles[0],
                    height: 70, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: TextField(
                controller: _captionController,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                maxLines: null,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(right: 10),
                  hintText: 'Write a caption...',
                  alignLabelWithHint: true,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
