import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/utils/image_picker.dart';
import 'package:insta_node_app/common_widgets/grid_icon.dart';
import 'package:insta_node_app/views/message/widgets/input_message_gallery.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../constants/dimension.dart';

class InputMessageWidget extends StatefulWidget {
  final List<String> media;
  final String recipientId;
  final TextEditingController controller;
  final VoidCallback handleCreateMessage;
  const InputMessageWidget(
      {super.key,
      required this.controller,
      required this.recipientId,
      required this.handleCreateMessage,
      required this.media});

  @override
  State<InputMessageWidget> createState() => _InputMessageWidgetState();
}

class _InputMessageWidgetState extends State<InputMessageWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  Future<void> callRestorablePicker(List<AssetEntity> assetList) async {
    if (!mounted) return;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.dPaddingSmall),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
    if (assetList.isEmpty) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      return;
    }
    List<String> images = [];
    for (int i = 0; i < assetList.length; i++) {
      final res = await imageUpload(await assetList[i].file, false);
      images.add(res);
    }
    setState(() {
      widget.media.addAll(images);
    });
    widget.handleCreateMessage();
    if (!mounted) return;
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Container(
              // margin: const EdgeInsets.all(value),
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(left: 5),
              decoration: ShapeDecoration(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  showModalBottomSheetCustom(
                    context,
                    GridIconWidget(
                      controller: widget.controller,
                    ),
                  );
                },
                icon: Icon(
                  FontAwesomeIcons.faceSmile,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                onChanged: (value) => setState(() {}),
                controller: widget.controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintText: 'Message...',
                ),
              ),
            ),
            widget.controller.text != ''
                ? TextButton(
                    onPressed: () {
                      widget.handleCreateMessage();
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ))
                : IconButton(
                    onPressed: () {
                      // callRestorablePicker();
                      showModalBottomSheetCustom(
                          context,
                          InputMessageMedia(
                            onSend: callRestorablePicker,
                            maxCount: 5,
                            requestType: RequestType.image,
                          ));
                    },
                    icon: Icon(
                      FontAwesomeIcons.image,
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
          ],
        ));
  }
}
