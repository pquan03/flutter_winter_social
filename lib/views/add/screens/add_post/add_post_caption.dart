import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/post_api.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:insta_node_app/views/keep_alive_screen.dart';
import 'package:insta_node_app/views/navigation_view.dart';
import 'package:insta_node_app/views/add/screens/widgets/preview.dart';
import 'package:insta_node_app/utils/animate_route.dart';
import 'package:provider/provider.dart';

import '../../../../constants/dimension.dart';

class AddPostCaptionScreen extends StatefulWidget {
  final List<Uint8List> imageList;
  const AddPostCaptionScreen({
    super.key,
    required this.imageList,
  });

  @override
  State<AddPostCaptionScreen> createState() => _AddPostCaptionScreenState();
}

class _AddPostCaptionScreenState extends State<AddPostCaptionScreen> {
  bool _isLoading = false;
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void handleCreatePost() async {
    setState(() {
      _isLoading = true;
    });
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final res = await PostApi()
        .createPost(_captionController.text, widget.imageList, token);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => KeepAlivePage(
                      child: MainAppScreen(
                    initPage: 0,
                  ))),
          (route) => false);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
      onPressed: () => Navigator.pop(context),
      title: 'New Post',
      action: [
        _isLoading
            ? Padding(
                padding: const EdgeInsets.only(right: Dimensions.dPaddingSmall),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              )
            : IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 30,
                  color: Colors.blue,
                ),
                onPressed: handleCreatePost,
              )
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.dPaddingSmall),
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
              onTap: () {
                Navigator.of(context).push(
                    createRoute(PreviewScreen(imagesBytes: widget.imageList)));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: Dimensions.dPaddingSmall),
                child: widget.imageList.isEmpty
                    ? SizedBox(
                        height: 60,
                        width: 60,
                        child: Container(
                          color: Colors.grey,
                        ))
                    : SizedBox(
                        height: 60,
                        width: 60,
                        child: Image.memory(
                          widget.imageList[0],
                          fit: BoxFit.cover,
                        )),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: TextField(
                controller: _captionController,
                maxLines: null,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(right: Dimensions.dPaddingSmall),
                  hintText: 'Write a caption...',
                  alignLabelWithHint: true,
                  hintStyle: TextStyle(),
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
