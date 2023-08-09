import 'package:flutter/material.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/screens/add_post.dart';
import 'package:insta_node_app/widgets/crop_result_view.dart';

class PickerCropResultScreen extends StatelessWidget {
  const PickerCropResultScreen({super.key, required this.cropStream});

  final Stream<InstaAssetsExportDetails> cropStream;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - kToolbarHeight;

    return StreamBuilder<InstaAssetsExportDetails>(
          stream: cropStream,
          builder: (context, snapshot) => LayoutScreen(
            title: 'New post',
            action: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 30,
                  color: Colors.blue,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddPostScreen(
                        croppedFiles: snapshot.data?.croppedFiles ?? [],
                      ),
                    ),
                  );
                },
              )
            ],
            child: CropResultView(
              selectedAssets: snapshot.data?.selectedAssets ?? [],
              croppedFiles: snapshot.data?.croppedFiles ?? [],
              progress: snapshot.data?.progress,
              heightFiles: height / 2,
              heightAssets: height / 4,
            ),
          ),
        );
  }
}
