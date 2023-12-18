import 'package:flutter/material.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/views/profile/screens/other_profile.dart';
import 'package:insta_node_app/views/profile/screens/profile.dart';
import 'package:provider/provider.dart';

class ReelCardInforWidget extends StatelessWidget {
  const ReelCardInforWidget({super.key, required this.reel});
  final Reel reel;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).auth.user;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (user!.sId != reel.user!.sId) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          OtherProfileScreen(userId: reel.user!.sId!)));
                } else {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ProfileScreen()));
                }
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: reel.user!.avatar != null
                    ? NetworkImage(reel.user!.avatar!)
                    : null,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              reel.user!.username!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              width: 10,
            ),
            if (user!.following!.contains(reel.user!.sId!) ||
                user.sId != reel.user!.sId!)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.white, width: 1)),
                child: Text(
                  'Follow',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        // content
        Text(
          reel.content!,
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 3,
        ),
        if (reel.user!.username! != '')
          SizedBox(
            height: 10,
          ),
        // song name
        Text(
          'Song name: ${reel.user!.username!}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
