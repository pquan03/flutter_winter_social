import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/models/post.dart';

class MediaMessageWidget extends StatelessWidget {
  final List<Images> media;
  const MediaMessageWidget({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ...media
            .map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ImageHelper.loadImageNetWork(e.url!,
                    height: 200, borderRadius: BorderRadius.circular(10))))
            .toList()
      ],
    );
  }
}
