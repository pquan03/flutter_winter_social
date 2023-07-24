

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/constants/asset_helper.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/post_api.dart';
import 'package:insta_node_app/screens/screens/messages.dart';
import 'package:insta_node_app/screens/screens/notifications.dart';
import 'package:insta_node_app/widgets/post_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken;
  const HomeScreen({super.key, required this.accessToken});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  void getPosts() async {
    final res = await PostApi().getPosts(widget.accessToken);
    if(res is List<Post>) {
      setState(() {
        _posts = res;
      });
    } else {
      print(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SvgPicture.asset(AssetHelper.icSvg, height: 32, color: Colors.white,),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.favorite_outline),
            )),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessageScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(FontAwesomeIcons.comment),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: _posts[index],);
        },
      ),
    );
  }
}