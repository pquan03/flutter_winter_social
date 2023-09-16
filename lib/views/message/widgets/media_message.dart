import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/utils/animate_route.dart';
import 'package:insta_node_app/views/add/screens/widgets/preview.dart';

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
                onTap: () {
                  // open popup render image
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PreviewScreen(imagesString: media, initpage: media.indexOf(e),))
                  );
                },
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Hero(
                      tag: e,
                      child: ImageHelper.loadImageNetWork(e,
                          fit: BoxFit.contain,
                          borderRadius: BorderRadius.circular(10)),
                    )),
              ))
              .toList()
        ],
      ),
    );
  }
}
