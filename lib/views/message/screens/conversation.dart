import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/constants/dimension.dart';
import 'package:insta_node_app/constants/size.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
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
    final dark = THelperFunctions.isDarkMode(context);
    return _isSearch
        ? SearchUserScreen(
            handleBack: handleBack,
          )
        : LayoutScreen(
            onPressed: () => Navigator.pop(context),
            title: '${user.username}',
            action: [
              IconButton(
                padding: const EdgeInsets.only(right: Dimensions.dPaddingSmall),
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
                      chatBloc
                          .add(ChatEventFetch(token: token, isRefresh: true));
                    },
                    child: ListView(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                top: Dimensions.dPaddingSmall)),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: TSizes.defaultSpace),
                          height: 40,
                          decoration: BoxDecoration(
                            color: dark ? Colors.grey[800] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            onTap: () => setState(() {
                              _isSearch = true;
                            }),
                            autofocus: false,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                size: 18,
                              ),
                              hintText: "Search",
                              hintStyle: Theme.of(context).textTheme.bodySmall,
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
                        chatState.listConversation.isEmpty
                            ? Center(
                                child: Text(
                                  'No messages',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            : Column(
                                children: chatState.listConversation
                                    .map((e) => CardConversationWidget(
                                          conversation: e,
                                          currentUserId: user.sId!,
                                        ))
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
