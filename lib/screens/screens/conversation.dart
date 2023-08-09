import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/bloc/conversation_bloc/conversation_bloc.dart';
import 'package:insta_node_app/bloc/conversation_bloc/conversation_event.dart';
import 'package:insta_node_app/bloc/conversation_bloc/conversation_state.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';
import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/screens/screens/message.dart';
import 'package:insta_node_app/screens/screens/search_user.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  final String accessToken;
  const ConversationScreen({super.key, required this.accessToken});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  bool _isSearch = false;

  @override
  void initState() {
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
    final accessToken = Provider.of<AuthProvider>(context).auth.accessToken!;
    return BlocProvider<ConversationBloc>(
      create: (context) =>
          ConversationBloc()..add(ConversationEventFectch(token: accessToken)),
      child: _isSearch
          ? SearchUserScreen(
              handleBack: handleBack,
            )
          : LayoutScreen(
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
              child: BlocBuilder<ConversationBloc, ConversationState>(
                  builder: (context, conversationState) {
                if (conversationState is ConversationLoading) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ...List.generate(
                          2,
                          (index) => buildTempMessage(),
                        )
                      ],
                    ),
                  );
                } else if (conversationState is ConversationError) {
                  return Center(
                    child: Text(conversationState.message),
                  );
                } else if (conversationState is ConversationSuccess) {
                  return RefreshIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onRefresh: () async {
                      context.read<ConversationBloc>().add(
                            ConversationEventFectch(token: accessToken),
                          );
                    },
                    child: ListView(
                      children: [
                        Padding(padding: const EdgeInsets.only(top: 10)),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(.3),
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
                        conversationState.listConversation!.isEmpty
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
                                  ...conversationState.listConversation!
                                      .map((e) => GestureDetector(
                                          onTap: () {
                                            if (e.isRead == false) {
                                              context
                                                  .read<ConversationBloc>()
                                                  .add(
                                                    ConversationEventRead(
                                                      token: widget.accessToken,
                                                      conversationId: e.sId!,
                                                    ),
                                                  );
                                            }
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MessageScreen(
                                                          conversationId: e.sId,
                                                          messages: e.messages!,
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
                  );
                }
                return Container();
              }),
            ),
    );
  }

  Widget buildConverationCard(Conversations cv) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    final recipient = user.sId == cv.recipients![0].sId
        ? cv.recipients![1]
        : cv.recipients![0];
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
                Text(
                  '${cv.messages![0].text} · ${DateFormat.yMMMd().format(DateTime.parse(cv.createdAt!))}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          cv.isRead! ? FontWeight.normal : FontWeight.bold),
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
