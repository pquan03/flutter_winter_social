import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/views/reel/screens/explore_list_reel.dart';

import '../../../constants/dimension.dart';

class ReelMessWidget extends StatelessWidget {
  final Reel reelMess;
  final String createdAt;
  const ReelMessWidget(
      {super.key, required this.reelMess, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ExploreListReelScreen(
                      reels: [reelMess],
                      initpage: 0,
                    )));
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.7,
        decoration: BoxDecoration(
            color: Colors.grey[400], borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.dPaddingSmall),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(reelMess.user!.avatar!),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    reelMess.user!.username!,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ],
              ),
            ),
            ImageHelper.loadImageNetWork(
              reelMess.backgroundUrl!,
            ),
            SizedBox(
              height: 10,
            ),
            // TextSpan
            Padding(
              padding: const EdgeInsets.all(Dimensions.dPaddingSmall),
              child: RichText(
                text: TextSpan(
                    text: reelMess.user!.username!,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text: '  ${reelMess.content}',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black))
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
