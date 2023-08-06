import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/constants/asset_helper.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/post_api.dart';
import 'package:insta_node_app/screens/screens/keep_alive_screen.dart';
import 'package:insta_node_app/screens/screens/conversation.dart';
import 'package:insta_node_app/screens/screens/notifications.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
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
  static int page = 1;
  static const int limit = 9;
  bool _isLoadMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getPosts();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void getPosts() async {
    if(_posts.isNotEmpty && _posts.length % limit != 0){
      setState(() {
        _isLoadMore = false;
      });  
      return;
    }
    final res = await PostApi().getPosts(widget.accessToken, page, limit);
    if (res is List) {
      setState(() {
        _posts = [..._posts, ...res];
        page++;
      });
    } else {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    }
  }

  void _deletePost(String postId) async {
    print('halo');
    final res = await PostApi().deletePost(postId, widget.accessToken);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _posts.removeWhere((post) => post.sId == postId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context).auth;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.black,
          title: SvgPicture.asset(
            AssetHelper.icSvg,
            height: 32,
            color: Colors.white,
          ),
          actions: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => KeepAlivePage(
                                  child: NotificationScreen(
                                accessToken: widget.accessToken,
                              ))));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.favorite_outline),
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConversationScreen(
                              accessToken: widget.accessToken,
                            )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(FontAwesomeIcons.comment),
                  ),
                ),
              ],
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _posts = [];
              page = 1;
            });
            getPosts();
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _posts.length + 1,
            itemBuilder: (context, index) {
              if (index == _posts.length) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Opacity(
                        opacity: _isLoadMore ? 1.0 : 0.0,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        )),
                  ),
                );
              }
              return PostCard(
                post: _posts[index],
                deletePost: _deletePost,
                auth: auth,
              );
            },
          ),
        ),
      ),
    );
  }
}
