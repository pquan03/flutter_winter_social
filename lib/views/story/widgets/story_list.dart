import 'package:flutter/material.dart';
import 'package:insta_node_app/models/story.dart';
import 'package:insta_node_app/views/add/screens/add_story/media_gallery_story.dart';
import 'package:insta_node_app/views/story/widgets/story_card.dart';
import 'package:insta_node_app/views/story/screens/winter_stories.dart';

class StoryListWidget extends StatefulWidget {
  final List<Stories> stories;
  const StoryListWidget({super.key, required this.stories});

  @override
  State<StoryListWidget> createState() => _StoryListWidgetState();
}

class _StoryListWidgetState extends State<StoryListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.stories.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              if (widget.stories[index].stories!.isEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MediaGalleryStoryScreen()));
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.down,
                        onDismissed: (_) => Navigator.of(context).pop(),
                        child: Dialog(
                          insetPadding: const EdgeInsets.all(0),
                          child: WinterStoriesPage(
                            listStories: widget.stories,
                            initPage: index,
                          ),
                        ),
                      );
                    });
              }
            },
            child: StoryCardWidget(
              currentIndex: index,
              showBorder: widget.stories[index].stories!.isNotEmpty,
              showIconAdd: index == 0,
              avatar: widget.stories[index].user!.avatar!,
              name: widget.stories[index].user!.username!,
            ));
      },
    );
  }
}
