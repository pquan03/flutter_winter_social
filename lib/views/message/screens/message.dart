import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_event.dart';
import 'package:insta_node_app/constants/size.dart';
import 'package:insta_node_app/utils/helpers/asset_helper.dart';
import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/message_api.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:insta_node_app/utils/socket_config.dart';
import 'package:insta_node_app/bloc/online_bloc/oneline_bloc.dart';
import 'package:insta_node_app/views/message/widgets/card_message.dart';
import 'package:insta_node_app/views/message/widgets/input_message.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessageScreen extends StatefulWidget {
  final String? conversationId;
  final UserPost user;
  final List<Messages> firstListMessages;
  const MessageScreen(
      {super.key,
      required this.user,
      required this.firstListMessages,
      this.conversationId});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late IO.Socket socket;
  final List<Messages> _messages = [];
  List<String> media = [];
  bool _isLoadMore = true;
  int page = 2;
  int limit = 20;

  @override
  void initState() {
    super.initState();
    SocketConfig.socket.on('addMessageToClient', (data) {
      if (!mounted) return;
      setState(() {
        _messages.addAll([...widget.firstListMessages]);
      });
    });
    if (widget.firstListMessages.length < limit) {
      setState(() {
        _isLoadMore = false;
      });
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _handleLoadMoreMessage();
      }
    });
  }

  @override
  void didChangeDependencies() {
    _messages.addAll([...widget.firstListMessages]);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<AuthProvider>(context, listen: false).auth.user!;
    final isOnline = OnlineBloc().state.contains(widget.user.sId);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: TSizes.appBarHeight,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              final msg = {
                'sender': currentUser.sId!,
                'recipient': widget.user.sId,
                'avatar': currentUser.avatar,
                'fullname': currentUser.fullname,
              };
              SocketConfig.callUser(msg);
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (_) => VideoCallScreen()));
            },
            icon: Icon(
              FontAwesomeIcons.phone,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              AudioPlayer player = AudioPlayer();
              player.play(AssetSource(AssetHelper.soundCall));
            },
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
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(widget.user.avatar!),
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
                        isOnline ? 'Active now' : 'Offline',
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
          padding: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
          child: Column(
            children: [
              Expanded(
                child: _messages.isNotEmpty
                    ? ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: _messages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _messages.length) {
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
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: CardMessageWidget(
                                message: _messages[index],
                                userAvatar: widget.user.avatar!),
                          );
                        },
                      )
                    : Container(),
              ),
              InputMessageWidget(
                  media: media,
                  handleCreateMessage: handleCreateMessage,
                  controller: _messageController,
                  recipientId: widget.user.sId!)
            ],
          )),
    );
  }

  void _handleLoadMoreMessage() async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    // if (widget.firstListMessages.isNotEmpty &&
    //     widget.firstListMessages.length % limit != 0) {
    //   setState(() {
    //     _isLoadMore = false;
    //   });
    //   return;
    // }
    final res = await MessageApi().getMessages(
        widget.conversationId != null
            ? widget.conversationId!
            : widget.user.sId!,
        accessToken,
        page,
        limit);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _messages.addAll([...res]);
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
      'conversationId': widget.conversationId ?? widget.user.sId,
      'avatar': currentUser.avatar,
      'username': currentUser.username,
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
      if (!mounted) return;
      final chatBloc = BlocProvider.of<ChatBloc>(context);
      _messages.insert(0, Messages.fromJson(res['message']));
      chatBloc.add(ChatEventAddMessage(
          conversation: Conversations.fromJson(res['conversation']),
          message: Messages.fromJson(
            res['message'],
          )));
      setState(() {
        media = [];
        _messageController.clear();
      });
    }
  }
}
