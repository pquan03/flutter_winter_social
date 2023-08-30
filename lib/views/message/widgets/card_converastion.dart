import 'package:flutter/material.dart';
import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/views/message/screens/message.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardConversationWidget extends StatelessWidget {
  const CardConversationWidget({super.key, required this.conversation});
  final Conversations conversation;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    final recipient = user.sId == conversation.recipients![0].sId
        ? conversation.recipients![1]
        : conversation.recipients![0];
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => MessageScreen(user: recipient, firstListMessages: conversation.messages!)));
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 1),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(recipient.avatar!),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipient.fullname!,
                    style: TextStyle(
                      fontWeight:
                          conversation.isRead! ? FontWeight.normal : FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      if (user.sId == conversation.messages!.first.senderId)
                        Row(
                          children: [
                            Text(
                              'You: ',
                              style: TextStyle(
                                fontWeight: conversation.isRead!
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                            if (conversation.messages!.first.call != null)
                              Text(
                                'You called ${conversation.messages!.first.call!.times} times',
                                style: TextStyle(
                                  fontWeight: conversation.isRead!
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                            if (conversation.messages!.first.text != null)
                              Text(
                                conversation.messages!.first.text!.length > 20 ? '${conversation.messages!.first.text!.substring(0, 20)}...' :
                                conversation.messages!.first.text!,
                                style: TextStyle(
                                  fontWeight: conversation.isRead!
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                            if (conversation.messages!.first.media!.isNotEmpty)
                              Text(
                                style: TextStyle(
                                  fontWeight: conversation.isRead!
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                                'sent ${conversation.messages!.first.media!.length} images',
                              )
                          ],
                        ),
                      if (user.sId != conversation.messages!.first.senderId)
                        Row(
                          children: [
                            Text(
                              '${recipient.username}: ',
                              style: TextStyle(
                                fontWeight: conversation.isRead!
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                            if (conversation.messages!.first.call != null)
                              Text(
                                'called ${conversation.messages!.first.call!.times} times',
                                style: TextStyle(
                                  fontWeight: conversation.isRead!
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                            if (conversation.messages!.first.text != null)
                              Text(
                                '${conversation.messages!.first.text}',
                                style: TextStyle(
                                  fontWeight: conversation.isRead!
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                            if (conversation.messages!.first.media!.isNotEmpty)
                              Text(
                                'sent ${conversation.messages!.first.media!.length} images',
                                style: TextStyle(
                                  fontWeight: conversation.isRead!
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              )
                          ],
                        ),
                      Text(
                        '· ${DateFormat.yMMMd().format(DateTime.parse(conversation.createdAt!))}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                conversation.isRead! ? FontWeight.normal : FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}