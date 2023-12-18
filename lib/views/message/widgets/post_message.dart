import 'package:flutter/material.dart';
import 'package:insta_node_app/utils/helpers/image_helper.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/views/post/screens/explore_list_post.dart';

import '../../../constants/dimension.dart';

class PostMessageWidget extends StatelessWidget {
  final Post postMess;
  final String createdAt;
  const PostMessageWidget(
      {super.key, required this.postMess, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ExploreListPostScreen(
                      posts: [postMess],
                      title: 'WinterGram',
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
                    backgroundImage: NetworkImage(postMess.userPost!.avatar!),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    postMess.userPost!.username!,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ],
              ),
            ),
            ImageHelper.loadImageNetWork(
              postMess.images!.first,
            ),
            SizedBox(
              height: 10,
            ),
            // TextSpan
            Padding(
              padding: const EdgeInsets.all(Dimensions.dPaddingSmall),
              child: RichText(
                text: TextSpan(
                    text: postMess.userPost!.username!,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text: '  ${postMess.content}',
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
