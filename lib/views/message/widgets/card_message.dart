import 'package:flutter/material.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/views/message/widgets/call_message.dart';
import 'package:insta_node_app/views/message/widgets/media_message.dart';
import 'package:insta_node_app/views/message/widgets/text_message.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardMessageWidget extends StatelessWidget {
  const CardMessageWidget({super.key, required this.message,  required this.userAvatar});
  final Messages message;
  final String userAvatar;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).auth.user!;
    bool isShowAvatar = message.senderId == currentUser.sId ? false : true;
    final color = message.senderId == currentUser.sId
        ? Colors.blue
        : Colors.grey.withOpacity(0.5);
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
              message.text != ''
                  ? TextMessageWidget(color: color, text: message.text!)
                  : Container(),
              // Image
              message.media!.isNotEmpty
                  ? MediaMessageWidget(media: message.media!, crossAxisAlignment: crossAxisAliment)
                  : Container(),
              // call
              message.call != null
                  ? CallMessageWidget(
                      call: message.call!, createAt: message.createdAt!)
                  : Container(),
              Text(
                  DateFormat('dd/MM/yyyy hh:mm a')
                      .format(DateTime.parse(message.createdAt!)),
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