import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/models/user.dart';
import 'package:insta_node_app/views/profile/screens/follow_user.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileUserInfoWidget extends StatelessWidget {
  final User user;
  final ScrollController? scrollController;
  const ProfileUserInfoWidget(
      {super.key, required this.user, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageHelper.loadImageNetWork(user.avatar!,
                borderRadius: BorderRadius.circular(50),
                fit: BoxFit.cover,
                height: 72,
                width: 72),
            const SizedBox(width: 24),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  startColumnItem(user.countPosts!, 'Posts', () {
                    scrollController?.animateTo(150,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  }),
                  startColumnItem(user.followers!.length, 'Followers', () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => FollowUserScreen(
                            initIndex: 0,
                            username: user.username!,
                            followers: user.followers!,
                            following: user.following!)));
                  }),
                  startColumnItem(user.following!.length, 'Following', () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => FollowUserScreen(
                            initIndex: 1,
                            username: user.username!,
                            followers: user.followers!,
                            following: user.following!)));
                  }),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        buildText(user.fullname!,
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        buildText(user.story!, TextStyle(fontSize: 16)),
        InkWell(
            onTap: () async {
              await launchUrl(
                Uri.parse(user.website!),
                mode: LaunchMode.externalApplication,
              );
            },
            child: buildText(
                user.website!, TextStyle(fontSize: 16, color: Colors.purple))),
      ],
    );
  }

  Widget startColumnItem(int number, String title, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              number.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildText(String text, TextStyle style) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
