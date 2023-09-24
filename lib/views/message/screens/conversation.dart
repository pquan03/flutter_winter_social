import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/utils/socket_config.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_event.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_state.dart';
import 'package:insta_node_app/views/message/screens/search_user_mess.dart';
import 'package:insta_node_app/views/message/widgets/card_converastion.dart';
import 'package:provider/provider.dart';

class Conversation extends StatefulWidget {
  const Conversation({super.key});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  bool _isSearch = false;

  @override
  void initState() {
          SocketConfig.socket.on('addMessageToClient', (data) {
      if (!mounted) return;
      setState(() {
        final message = Messages.fromJson(data);
        final chatBloc = BlocProvider.of<ChatBloc>(context);
        chatBloc.add(ChatEventAddMessage(message: message));
      });
    });
    super.initState();
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
            onPressed: () => Navigator.pop(context),
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
            child: 
                BlocBuilder<ChatBloc, ChatState>(builder: (context, chatState) {
              if (chatState is ChatStateLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              } else if (chatState is ChatStateError) {
                return Center(
                  child: Text(chatState.error),
                );
              } else if (chatState is ChatStateSuccess) {
                return RefreshIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onRefresh: () async {
                      final token =
                          Provider.of<AuthProvider>(context, listen: false)
                              .auth
                              .accessToken!;
                      final chatBloc = BlocProvider.of<ChatBloc>(context);
                      chatBloc.add(ChatEventFetch(token: token, isRefresh: true));
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
                        Column(
                          children: chatState.listConversation
                              .map((e) =>
                                  CardConversationWidget(conversation: e))
                              .toList(),
                        )
                      ],
                    ));
              } else {
                return Center(
                  child: Text('Something went wrong'),
                );
              }
            }));
  }
}
