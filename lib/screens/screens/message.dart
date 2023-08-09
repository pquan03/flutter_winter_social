import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/message_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/widgets/call_message.dart';
import 'package:insta_node_app/widgets/input_message.dart';
import 'package:insta_node_app/widgets/media_message.dart';
import 'package:insta_node_app/widgets/text_message.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  final String? conversationId;
  final UserPost user;
  final List<Messages> messages;
  const MessageScreen(
      {super.key,
      required this.user,
      required this.messages,
      this.conversationId});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Messages> messages = [];
  List<String> media = [];
  bool _isLoadMore = true;
  int page = 2;
  int limit = 20;

  @override
  void initState() {
    super.initState();
    messages = widget.messages;
    _isLoadMore = messages.length < limit ? false : true;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _handleLoadMoreMessage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _scrollController.dispose();
  }

  void _handleLoadMoreMessage() async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    if (messages.isNotEmpty && messages.length % limit != 0) {
      setState(() {
        _isLoadMore = false;
      });
      return;
    }
    final res = await MessageApi()
        .getMessages(widget.conversationId!, accessToken, page, limit);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        messages = [...messages, ...res];
        page++;
      });
    }
  }

  void handleCreateMessage() async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final currentUser =
        Provider.of<AuthProvider>(context, listen: false).auth.user!;
    final message = {
      'text': _messageController.text,
      'senderId': currentUser.sId,
      'recipientId': widget.user.sId,
      'media': media,
      'call': null
    };
    final res = await MessageApi().createMessageText(message, accessToken);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        messages.insert(0, res);
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<AuthProvider>(context, listen: false).auth.user!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.phone,
            ),
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
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
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
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Active now',
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
          child: Column(
            children: [
              Expanded(
                child: messages.isNotEmpty
                    ? ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: messages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == messages.length) {
                            return SizedBox(
                                height: 70,
                                child: Opacity(
                                    opacity: _isLoadMore ? 1 : 0,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ))));
                          }
                          return buildMessageCard(
                              messages[index], currentUser.sId!);
                        },
                      )
                    : Container(),
              ),
              InputMessageWidget(
                  handleCreateMessage: handleCreateMessage,
                  controller: _messageController,
                  recipientId: widget.user.sId!)
            ],
          )),
    );
  }

  Widget buildMessageCard(Messages message, String currentId) {
    bool isShowAvatar = message.senderId == currentId ? false : true;
    final color = message.senderId == currentId
        ? Colors.blue
        : Colors.grey.withOpacity(0.5);
    final mainAxisAlignment = message.senderId == currentId
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;
    final crossAxisAliment = message.senderId == currentId
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    return Row(
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
    );
  }
}
