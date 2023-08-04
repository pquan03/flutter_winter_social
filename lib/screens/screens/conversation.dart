import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';
import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/message_api.dart';
import 'package:insta_node_app/screens/screens/message.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  final String accessToken;
  const ConversationScreen({super.key, required this.accessToken});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<Conversations> _conversations = [];

  @override
  void initState() {
    super.initState();
    getCoversations();
  }

  void getCoversations() async {
    setState(() {
      _isLoading = true;
    });
    final res = await MessageApi().getConversations(widget.accessToken);
    if (res is List) {
      setState(() {
        _conversations = [...res];
      });
    } else {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    return LayoutScreen(
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
      child: RefreshIndicator(
        onRefresh: () async {
          getCoversations();
        },
        child: ListView(
          children: [
            Padding(padding: const EdgeInsets.only(top: 10)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  suffixIcon: _searchController.text != ''
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _searchController.text = '';
                            });
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      : null,
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            _isLoading
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
                : Column(
                    children: [
                      ..._conversations.map((e) => buildConverationCard(e))
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void handleReadMessage(Conversations cv) async {
    setState(() {
      _conversations = _conversations.map((e) {
        if (e.sId == cv.sId) {
          e.isRead = true;
        }
        return e;
      }).toList();
    });
    await MessageApi().readMessage(cv.sId!, widget.accessToken);
  }

  Widget buildConverationCard(Conversations cv) {
    return GestureDetector(
      onTap: () {
        if(cv.isRead == false) {
          handleReadMessage(cv);
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessageScreen(user: cv.recipients![1], conversationId: cv.sId!,)));
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 1),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(cv.recipients![1].avatar!),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cv.recipients![1].fullname!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: cv.isRead! ? FontWeight.normal : FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${cv.text!} · ${DateFormat.yMMMd().format(DateTime.parse(cv.createdAt!))}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: cv.isRead! ? FontWeight.normal : FontWeight.bold
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
