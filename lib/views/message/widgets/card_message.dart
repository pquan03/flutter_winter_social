import 'package:flutter/material.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:insta_node_app/utils/helpers/image_helper.dart';
import 'package:insta_node_app/constants/dimension.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/views/message/widgets/call_message.dart';
import 'package:insta_node_app/views/message/widgets/media_message.dart';
import 'package:insta_node_app/views/message/widgets/post_message.dart';
import 'package:insta_node_app/views/message/widgets/reel_message.dart';
import 'package:insta_node_app/views/message/widgets/text_message.dart';
import 'package:provider/provider.dart';

class CardMessageWidget extends StatelessWidget {
  const CardMessageWidget(
      {super.key, required this.message, required this.userAvatar});
  final Messages message;
  final String userAvatar;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).auth.user!;
    bool isShowAvatar = message.senderId == currentUser.sId ? false : true;
    final backgroundColor = message.senderId == currentUser.sId
        ? Colors.blue
        : Theme.of(context).colorScheme.primaryContainer;
    final textColor = message.senderId == currentUser.sId
        ? Colors.white
        : Theme.of(context).colorScheme.secondary;
    final mainAxisAlignment = message.senderId == currentUser.sId
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;
    final crossAxisAliment = message.senderId == currentUser.sId
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isShowAvatar
              ? CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(userAvatar),
                )
              : Container(),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: crossAxisAliment,
            children: [
              message.linkPost != null
                  ? PostMessageWidget(
                      postMess: message.linkPost!,
                      createdAt: message.createdAt!)
                  : Container(),
              message.linkReel != null
                  ? ReelMessWidget(
                      reelMess: message.linkReel!,
                      createdAt: message.createdAt!)
                  : Container(),
              message.text != ''
                  ? message.linkStory != null
                      ? Stack(
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.7,
                              padding: const EdgeInsets.only(
                                  right: Dimensions.dPaddingSmall,
                                  bottom: Dimensions.dPaddingMedium),
                              child: InkWell(
                                onTap: () {},
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      Colors.white.withOpacity(0.5),
                                      BlendMode.srcATop),
                                  child: ImageHelper.loadImageNetWork(
                                      THelperFunctions.replaceMp4ToPng(
                                          message.linkStory!.media!.media),
                                      fit: BoxFit.contain,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: isShowAvatar ? null : 0,
                                child: TextMessageWidget(
                                    backgroundColor: backgroundColor,
                                    textColor: textColor,
                                    text: message.text!))
                          ],
                        )
                      : TextMessageWidget(
                          backgroundColor: backgroundColor,
                          textColor: textColor,
                          text: message.text!)
                  : Container(),
              // Image
              message.media!.isNotEmpty
                  ? MediaMessageWidget(
                      media: message.media!,
                      crossAxisAlignment: crossAxisAliment)
                  : Container(),
              // call
              message.call != null
                  ? CallMessageWidget(
                      call: message.call!, createAt: message.createdAt!)
                  : Container(),
              Text( THelperFunctions.convertTimeAgo(message.createdAt!),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
