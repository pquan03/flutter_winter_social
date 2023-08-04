import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/bloc/message_bloc/message_bloc.dart';
import 'package:insta_node_app/bloc/message_bloc/message_event.dart';
import 'package:insta_node_app/bloc/message_bloc/message_state.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/widgets/call_message.dart';
import 'package:insta_node_app/widgets/input_message.dart';
import 'package:insta_node_app/widgets/media_message.dart';
import 'package:insta_node_app/widgets/text_message.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  final String conversationId;
  final UserPost user;
  const MessageScreen({super.key, required this.user, required this.conversationId});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessToken = Provider.of<AuthProvider>(context).auth.accessToken!;
    final userCredential = Provider.of<AuthProvider>(context).auth.user!;
    return BlocProvider<MessageBloc>(
      create: (_) => MessageBloc()
        ..add(MessageEventFecth(userId: widget.user.sId!, token: accessToken)),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            actions: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(FontAwesomeIcons.phone),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(FontAwesomeIcons.video),
              ),
            ],
            title: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, {
                      'conversationId': widget.conversationId,
                      'lastMessage' : 
                    });
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: Row(
                    children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.user.avatar!),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.fullname!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Active 3h ago',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                    ],
                  ),
                )
              ],
            ),
          ),
          body: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Expanded(
                child: BlocBuilder<MessageBloc, MessageState>(
                  builder: (context, messageState) {
                    if (messageState is MessageStateLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else if (messageState is MessageStateSuccess) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              reverse: true,
                              itemCount: messageState.listMessage.length,
                              itemBuilder: (context, index) {
                                return buildMessageCard(messageState.listMessage[index],
                                    userCredential.sId!);
                              },
                            ),
                          ),
                          InputMessageWidget(controller: _messageController, recipientId: widget.user.sId!,)
                        ],
                      );
                    } else if (messageState is MessageStateError) {
                      return Center(
                        child: Text(messageState.error),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              )),
        ),
      ),
    );
  }

  Widget buildMessageCard(Messages message, String currentId) {
    bool isShowAvatar = message.sender == currentId ? false : true;
    final color = message.sender == currentId
        ? Colors.blue
        : Colors.grey.withOpacity(0.5);
    final mainAxisAlignment = message.sender == currentId
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;
    final crossAxisAliment = message.sender == currentId
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Expanded(
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isShowAvatar
                ? CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(widget.user.avatar!),
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
                    ? MediaMessageWidget(media: message.media!)
                    : Container(),
                // call
                message.call != null
                    ? CallMessageWidget(
                        call: message.call!, createAt: message.createdAt!)
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
