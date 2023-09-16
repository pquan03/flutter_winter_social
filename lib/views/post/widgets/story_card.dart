import 'package:flutter/material.dart';
import 'package:insta_node_app/views/add/screens/add_story/media_gallery_story.dart';

class StoryCardWidget extends StatelessWidget {
  final int currentIndex;
  final bool showIconAdd;
  final bool showBorder;
  final String name;
  final String avatar;
  const StoryCardWidget(
      {super.key,
      required this.currentIndex,
      required this.avatar,
      required this.name,
      required this.showIconAdd,
      required this.showBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: showBorder
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            // boder color instagram
                            border: Border.all(color: Colors.pink, width: 4),
                          )
                        : null,
                    child: Hero(
                      tag: 'story_$currentIndex',
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: NetworkImage(avatar),
                      ),
                    ),
                  ),
                  if (showIconAdd == true)
                    Positioned(
                      right: -2,
                      bottom: 5,
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => MediaGalleryStoryScreen())),
                        child: CircleAvatar(
                          radius: 15,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            )
          ],
        ));
  }
}
