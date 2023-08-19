import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/post_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/widgets/post_card.dart';
import 'package:provider/provider.dart';

class SavedPostScreen extends StatefulWidget {
  const SavedPostScreen({super.key});

  @override
  State<SavedPostScreen> createState() => _SavedPostScreenState();
}

class _SavedPostScreenState extends State<SavedPostScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    handleGetSavedPost();
  }

  void handleGetSavedPost() async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken;
    final res = await PostApi().getSavedPosts(accessToken!);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _posts = [...res];
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _deletePost(String postId) async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken;
    final res = await PostApi().deletePost(postId, accessToken!);
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
    final auth = Provider.of<AuthProvider>(context, listen: false).auth;
    return LayoutScreen(
        title: 'Saved post',
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : _posts.isEmpty
                ? Center(
                    child: Text('No saved post'),
                  )
                : RefreshIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                  onRefresh: ()async {
                    setState(() {
                      _isLoading = true;
                    });
                    handleGetSavedPost();
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
                    ),
                ));
  }
}
