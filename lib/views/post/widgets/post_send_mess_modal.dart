import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/message_api.dart';
import 'package:insta_node_app/recources/user_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_event.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_state.dart';
import 'package:provider/provider.dart';

class PostSendMessModal extends StatefulWidget {
  final Post post;
  const PostSendMessModal({super.key, required this.post});

  @override
  State<PostSendMessModal> createState() => _PostSendMessModalState();
}

class _PostSendMessModalState extends State<PostSendMessModal> {
  late TextEditingController _searchController;
  List<UserPost> _userFollowers = [];
  bool _isLoading = true;
  UserPost selectedUser = UserPost();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 400), () {
      handleGetUserFollower();
    });
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
      ),
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          Column(
            children: [
              TextField(
                controller: _searchController,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    size: 28,
                  ),
                  suffixIcon: Icon(
                    Icons.person_add,
                    size: 28,
                  ),
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  hintText: 'Search user',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              _isLoading
                  ? SizedBox(
                      height: 300,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.blue,
                      )),
                    )
                  : Expanded(
                      child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _userFollowers.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _userFollowers.length) {
                          return SizedBox(
                            height: 50,
                          );
                        }
                        return ListTile(
                          onTap: () => setState(() {
                            selectedUser = _userFollowers[index];
                          }),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(_userFollowers[index].avatar!),
                          ),
                          title: Text(_userFollowers[index].username!),
                          subtitle: Text(_userFollowers[index].fullname!),
                          // select user
                          trailing: Radio(
                            activeColor: Colors.lightBlue,
                            overlayColor:
                                MaterialStateProperty.all(Colors.grey),
                            value: _userFollowers[index],
                            groupValue: selectedUser,
                            onChanged: (value) {},
                          ),
                        );
                      },
                    )),
            ],
          ),
          if (selectedUser.username != null)
            Positioned(
              bottom: 5,
              left: 5,
              right: 5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => handleCreateMessage(selectedUser),
                child: Text(
                  'Send',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void handleGetUserFollower() async {
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final user = Provider.of<AuthProvider>(context, listen: false).auth.user!;
    final res = await UserApi().getInfoListFollow(user.followers!, token);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _userFollowers = [..._userFollowers, ...res];
        _isLoading = false;
      });
    }
  }

  void handleCreateMessage(UserPost user) async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final currentUser =
        Provider.of<AuthProvider>(context, listen: false).auth.user!;
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final state = chatBloc.state;
    if (state is ChatStateSuccess) {
      final listConversation = state.listConversation;
      final currentConversation = listConversation.firstWhere((element) {
        final listUser = element.recipients!.map((e) => e.sId).toList();
        if (listUser.contains(currentUser.sId) && listUser.contains(user.sId)) {
          return true;
        } else {
          return false;
        }
      }, orElse: () {
        return Conversations();
      });
      final message = {
        'conversationId': currentConversation.sId ?? user.sId,
        'avatar': currentUser.avatar,
        'username': currentUser.username,
        'text': '',
        'linkPost': widget.post,
        'senderId': currentUser.sId,
        'recipientId': user.sId,
        'media': [],
        'call': null
      };
      final res = await MessageApi().createMessageText(message, accessToken);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        if (!mounted) return;
        final chatBloc = BlocProvider.of<ChatBloc>(context);
        chatBloc.add(ChatEventAddMessage(
            conversation: Conversations.fromJson(res['conversation']),
            message: Messages.fromJson(res['message'])));
      }
    }
  }
}
