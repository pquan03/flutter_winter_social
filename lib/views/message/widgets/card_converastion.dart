import 'package:flutter/material.dart';
import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/message_api.dart';
import 'package:insta_node_app/utils/time_ago_custom.dart';
import 'package:insta_node_app/bloc/online_bloc/oneline_bloc.dart';
import 'package:insta_node_app/views/message/screens/message.dart';
import 'package:provider/provider.dart';

class CardConversationWidget extends StatefulWidget {
  const CardConversationWidget({super.key, required this.conversation});
  final Conversations conversation;

  @override
  State<CardConversationWidget> createState() => _CardConversationWidgetState();
}

class _CardConversationWidgetState extends State<CardConversationWidget> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    final token = Provider.of<AuthProvider>(context).auth.accessToken!;
    final recipient = user.sId == widget.conversation.recipients![0].sId
        ? widget.conversation.recipients![1]
        : widget.conversation.recipients![0];
    final fontWeight = widget.conversation.isRead!.contains(user.sId)
        ? FontWeight.normal
        : FontWeight.bold;
    final isOnline = OnlineBloc().state.contains(recipient.sId);
    return InkWell(
      onTap: () async {
        handleReadMessage(user.sId!, token);
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MessageScreen(
                user: recipient,
                firstListMessages: widget.conversation.messages!)));
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 1),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(recipient.avatar!),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                )
              ],
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
                      fontWeight: fontWeight,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      if (user.sId ==
                          widget.conversation.messages!.first.senderId)
                        Row(
                          children: [
                            Text(
                              'You: ',
                              style: TextStyle(
                                fontWeight: fontWeight,
                              ),
                            ),
                            if (widget.conversation.messages!.first.call !=
                                null)
                              Text(
                                'You called ${widget.conversation.messages!.first.call!.times} times',
                                style: TextStyle(
                                  fontWeight: fontWeight,
                                ),
                              ),
                            if (widget.conversation.messages!.first.text !=
                                null)
                              Text(
                                widget.conversation.messages!.first.text!
                                            .length >
                                        20
                                    ? '${widget.conversation.messages!.first.text!.substring(0, 20)}...'
                                    : widget.conversation.messages!.first.text!,
                                style: TextStyle(
                                  fontWeight: fontWeight,
                                ),
                              ),
                            if (widget
                                .conversation.messages!.first.media!.isNotEmpty)
                              Text(
                                style: TextStyle(
                                  fontWeight: fontWeight,
                                ),
                                'sent ${widget.conversation.messages!.first.media!.length} images',
                              )
                          ],
                        ),
                      if (user.sId !=
                          widget.conversation.messages!.first.senderId)
                        Row(
                          children: [
                            Text(
                              '${recipient.username}: ',
                              style: TextStyle(
                                fontWeight: fontWeight,
                              ),
                            ),
                            if (widget.conversation.messages!.first.call !=
                                null)
                              Text(
                                'called ${widget.conversation.messages!.first.call!.times} times',
                                style: TextStyle(
                                  fontWeight: fontWeight,
                                ),
                              ),
                            if (widget.conversation.messages!.first.text !=
                                null)
                              Text(
                                '${widget.conversation.messages!.first.text}',
                                style: TextStyle(
                                  fontWeight: fontWeight,
                                ),
                              ),
                            if (widget
                                .conversation.messages!.first.media!.isNotEmpty)
                              Text(
                                'sent ${widget.conversation.messages!.first.media!.length} images',
                                style: TextStyle(
                                  fontWeight: fontWeight,
                                ),
                              )
                          ],
                        ),
                      Text(
                        '· ${convertTimeAgo(widget.conversation.messages!.first.createdAt!)}',
                        style: TextStyle(fontSize: 14, fontWeight: fontWeight),
                      ),
                      Spacer(),
                      if (widget.conversation.isRead!.contains(user.sId) ==
                          false)
                        Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            )),
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

  void handleReadMessage(String userId, String token) async {
    if (widget.conversation.isRead!.contains(userId) == false) {
      await MessageApi().readMessage(widget.conversation.sId!, token);
      if (!mounted) return;
      setState(() {
        widget.conversation.isRead!.add(userId);
      });
    }
  }
}
