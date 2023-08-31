import 'package:flutter/material.dart';
import 'package:insta_node_app/models/story.dart';
import 'package:insta_node_app/views/post/widgets/story_card.dart';
import 'package:insta_node_app/views/story/screens/story.dart';

class StoryListWidget extends StatefulWidget {
  final List<Story> stories;
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
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => StoryScreen(story: widget.stories[index]))),
            child: StoryCardWidget(
              showIconAdd: index == 0,
              avatar: widget.stories[index].user!.avatar!,
              name: widget.stories[index].user!.username!,
            ));
      },
    );
  }
}
