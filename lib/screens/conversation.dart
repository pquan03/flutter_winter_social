import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';
import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/message_api.dart';
import 'package:insta_node_app/screens/message.dart';
import 'package:insta_node_app/screens/search_user_mess.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/utils/socket_config.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  final String accessToken;
  final List<Conversations> conversations;
  const ConversationScreen({super.key, required this.accessToken, required this.conversations});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<Conversations> _conversations = [];
  bool _isSearch = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
      SocketConfig.socket.on('addMessageToClient', (data) {
      if (!mounted) return;
      setState(() {
        final message = Messages.fromJson(data);
        final conversation = _conversations.firstWhere(
            (element) => element.sId == message.conversationId);
        conversation.isRead = false;
        conversation.messages!.insert(0, message);
        _conversations.removeWhere(
            (element) => element.sId == message.conversationId);
        _conversations.insert(0, conversation);
      });
    });
    if(widget.conversations.isEmpty) {
      handleLoadConversation();
    } else {
      setState(() {
        _conversations = widget.conversations;
        _isLoading = false;
      });
    }
  }

  void handleLoadConversation() async {
    setState(() {
      _isLoading = true;
    });
    final res = await MessageApi().getConversations(widget.accessToken);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      if (!mounted) return;
      setState(() {
        _conversations = [..._conversations, ...res];
        _isLoading = false;
      });
    }
  }

  void handleBack() {
    setState(() {
      _isSearch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    return _isSearch
        ? SearchUserScreen(
            handleBack: handleBack,
          )
        : LayoutScreen(
            onPressed: () => Navigator.pop(context, _conversations),
            title: '${user.username}',
            action: [
              IconButton(
                padding: const EdgeInsets.only(right: 10),
                onPressed: () {},
                icon: const Icon(
                  FontAwesomeIcons.video,
                  size: 25,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  FontAwesomeIcons.penToSquare,
                  size: 25,
                ),
              ),
            ],
            child: _isLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ...List.generate(
                          2,
                          (index) => buildTempMessage(),
                        )
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onRefresh: () async {
                      setState(() {
                        _conversations = [];
                        _isLoading = true;
                      });
                      handleLoadConversation();
                    },
                    child: ListView(
                      children: [
                        Padding(padding: const EdgeInsets.only(top: 10)),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            onTap: () => setState(() {
                              _isSearch = true;
                            }),
                            autofocus: false,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: "Search",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Messages',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _conversations.isEmpty
                            ? Center(
                                child: Text(
                                  'No message',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              )
                            : Column(
                                children: <Widget>[
                                  ..._conversations
                                      .map((e) => GestureDetector(
                                          onTap: () async {
                                            // if (e.isRead == false) {
                                            //   await MessageApi().readMessage(e.sId!, widget.accessToken);
                                            // }
                                            // if(!mounted) return;
                                            Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                MessageScreen(
                                                                  conversationId:
                                                                      e.sId,
                                                                  firstListMessages:
                                                                      e.messages!,
                                                                  user: user.sId ==
                                                                          e.recipients![0]
                                                                              .sId
                                                                      ? e.recipients![1]
                                                                      : e.recipients![0],
                                                                )));
                                          },
                                          child: buildConverationCard(e)))
                                      .toList()
                                ],
                              ),
                      ],
                    ),
                  ),
          );
  }

  Widget buildConverationCard(Conversations cv) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    final recipient = user.sId == cv.recipients![0].sId
        ? cv.recipients![1]
        : cv.recipients![0];
    print(recipient.toString());
    return Container(
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
                        cv.isRead! ? FontWeight.normal : FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    if (user.sId == cv.messages!.first.senderId)
                      Row(
                        children: [
                          Text(
                            'You: ',
                            style: TextStyle(
                              fontWeight: cv.isRead!
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          if (cv.messages!.first.call != null)
                            Text(
                              'You called ${cv.messages!.first.call!.times} times',
                              style: TextStyle(
                                fontWeight: cv.isRead!
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                          if (cv.messages!.first.text != null)
                            Text(
                              cv.messages!.first.text!.length > 20 ? '${cv.messages!.first.text!.substring(0, 20)}...' :
                              cv.messages!.first.text!,
                              style: TextStyle(
                                fontWeight: cv.isRead!
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                          if (cv.messages!.first.media!.isNotEmpty)
                            Text(
                              style: TextStyle(
                                fontWeight: cv.isRead!
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                              'sent ${cv.messages!.first.media!.length} images',
                            )
                        ],
                      ),
                    if (user.sId != cv.messages!.first.senderId)
                      Row(
                        children: [
                          Text(
                            '${recipient.username}: ',
                            style: TextStyle(
                              fontWeight: cv.isRead!
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          if (cv.messages!.first.call != null)
                            Text(
                              'called ${cv.messages!.first.call!.times} times',
                              style: TextStyle(
                                fontWeight: cv.isRead!
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                          if (cv.messages!.first.text != null)
                            Text(
                              '${cv.messages!.first.text}',
                              style: TextStyle(
                                fontWeight: cv.isRead!
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                          if (cv.messages!.first.media!.isNotEmpty)
                            Text(
                              'sent ${cv.messages!.first.media!.length} images',
                              style: TextStyle(
                                fontWeight: cv.isRead!
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            )
                        ],
                      ),
                    Text(
                      '· ${DateFormat.yMMMd().format(DateTime.parse(cv.createdAt!))}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              cv.isRead! ? FontWeight.normal : FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTempMessage() {
    return LoadingShimmer(
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.35,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
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
