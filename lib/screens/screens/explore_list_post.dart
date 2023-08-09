
import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/post_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/widgets/post_card.dart';
import 'package:provider/provider.dart';

class ExploreListPostScreen extends StatefulWidget {
  final String title;
  final List<Post> posts;
  final String accessToken;
  const ExploreListPostScreen({super.key, required this.posts, required this.accessToken, required this.title});

  @override
  State<ExploreListPostScreen> createState() => _ExploreListPostScreenState();
}

class _ExploreListPostScreenState extends State<ExploreListPostScreen> {
  bool _isLoading = true;
  List<Post> _posts = [];
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _posts = [...widget.posts];
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        handleGetMorePosts();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void handleGetMorePosts() async {
    setState(() {
      _isLoading = true;
    });


    setState(() {
      _isLoading = false;
    });
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
    final Auth auth = Provider.of<AuthProvider>(context).auth;
    return LayoutScreen(
      title: widget.title,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length + 1,
        itemBuilder: (context, index) {
              if (index == _posts.length) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Opacity(
                        opacity: _isLoading ? 1.0 : 0.0,
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
      )
    );
  }
}