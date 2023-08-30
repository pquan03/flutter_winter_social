import 'package:flutter/material.dart';

class ChooseCreatePostModalWidget extends StatelessWidget {
  const ChooseCreatePostModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Wrap(
        children: [
          ...listData.map((e) => ListTile(
            leading: Icon(e.icon),
            title: Text(e.title),
            onTap: () {},
          )),
        ],
      ),
    );
  }

}
  List<TypeAddPost> listData = [
    TypeAddPost(title: 'Feed Post', icon: Icons.movie_edit),
    TypeAddPost(title: 'Story', icon: Icons.add_circle_outline),
    TypeAddPost(title: 'Reels', icon: Icons.video_camera_back_outlined),
  ];

class TypeAddPost {
  final String title;
  final IconData icon;
  const TypeAddPost({required this.title, required this.icon});
}