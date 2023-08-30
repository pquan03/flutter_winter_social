import 'package:flutter/material.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/views/post/widgets/story_card.dart';
import 'package:provider/provider.dart';

class StoryListWidget extends StatefulWidget {
  const StoryListWidget({super.key});

  @override
  State<StoryListWidget> createState() => _StoryListWidgetState();
}

class _StoryListWidgetState extends State<StoryListWidget> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index) {
        return StoryCardWidget(avatar: user.avatar!,);
      },
    );
  }
}
