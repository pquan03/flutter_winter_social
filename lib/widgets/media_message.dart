import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/screens/preview.dart';
import 'package:insta_node_app/utils/animate_route.dart';

class MediaMessageWidget extends StatelessWidget {
  final List<String> media;
  final CrossAxisAlignment crossAxisAlignment;
  const MediaMessageWidget({super.key, required this.media, required this.crossAxisAlignment});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: <Widget>[
          ...media
              .map((e) => GestureDetector(
                onTap: () => Navigator.of(context).push(createRoute(PreviewScreen(imagesString: media,))),
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ImageHelper.loadImageNetWork(e,
                        fit: BoxFit.contain,
                        borderRadius: BorderRadius.circular(10))),
              ))
              .toList()
        ],
      ),
    );
  }
}
