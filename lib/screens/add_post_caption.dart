import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/screens/preview.dart';
import 'package:insta_node_app/utils/animate_route.dart';

class AddPostCaptionScreen extends StatefulWidget {
  final Function navigationPreTapped;
  final bool isLoading;
  final Function handleCreatePost;
  final List<Uint8List> imageList;
  final TextEditingController controller;
  const AddPostCaptionScreen(
      {super.key,
      required this.navigationPreTapped,
      required this.isLoading,
      required this.handleCreatePost,
      required this.imageList,
      required this.controller
      });

  @override
  State<AddPostCaptionScreen> createState() => _AddPostCaptionScreenState();
}

class _AddPostCaptionScreenState extends State<AddPostCaptionScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
      onPressed: () => widget.navigationPreTapped(),
      title: 'New Post',
      action: [
        widget.isLoading
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
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
                onPressed: () => widget.handleCreatePost(),
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
              onTap: () {
                Navigator.of(context).push(
                    createRoute(PreviewScreen(imagesBytes: widget.imageList)));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
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
                controller: widget.controller,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: null,
                textDirection: TextDirection.ltr,
                cursorColor: Colors.green,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(right: 10),
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
