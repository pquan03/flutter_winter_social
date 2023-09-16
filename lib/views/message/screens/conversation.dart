import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/message_api.dart';
import 'package:insta_node_app/views/message/widgets/card_converastion.dart';
import 'package:insta_node_app/views/message/widgets/temp_shimmer_card_conversation.dart';
import 'package:insta_node_app/views/message/screens/search_user_mess.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/utils/socket_config.dart';
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
        conversation.isRead = ['${message.senderId}'];
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
                          (index) => CardTempConversation(),
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
                                      .map((e) => CardConversationWidget(conversation: e,))
                                      .toList()
                                ],
                              ),
                      ],
                    ),
                  ),
          );
  }

}
