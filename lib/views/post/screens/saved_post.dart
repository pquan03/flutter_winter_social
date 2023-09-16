import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/post_api.dart';
import 'package:insta_node_app/recources/reel_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/views/post/screens/explore_list_post.dart';
import 'package:insta_node_app/views/reel/screens/explore_list_reel.dart';
import 'package:provider/provider.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _SavedScreenState extends State<SavedScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  bool _isLoading = false;
  List<Post> _posts = [];
  List<Reel> _reels = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    handleGetSavedPost();
    _tabController.addListener(() {
      if (_reels.isEmpty && _tabController.index == 1) {
        handleGetSavedReel();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void handleGetSavedReel() async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken;
    final res = await ReelApi().getSavedReel(accessToken!);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _reels = [...res];
      });
    }
    setState(() {
      _isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              'All posts',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              child: Icon(Icons.grid_on_outlined),
            ),
            Tab(child: Icon(Icons.movie_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // controller: _scrollController,
                  child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: [
                      ...[..._posts, ProfilePost.fromJson({})]
                          .asMap()
                          .entries
                          .map((e) {
                        if (e.key == _posts.length) {
                          return StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 1,
                              child: Opacity(
                                opacity: _isLoading ? 1 : 0,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ));
                        }
                        return StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: GestureDetector(
                              onTap: () {
                                final newListPost = [..._posts];
                                final tempPost = newListPost[e.key];
                                newListPost.removeAt(e.key);
                                newListPost.insert(0, tempPost);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ExploreListPostScreen(
                                          title: 'Posts',
                                          posts: newListPost,
                                        )));
                              },
                              child: ImageHelper.loadImageNetWork(
                                  _posts[e.key].images![0],
                                  fit: BoxFit.cover)),
                        );
                      }).toList()
                    ],
                  ),
                ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // controller: _scrollController,
                  child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: [
                      ...[..._reels, ProfilePost.fromJson({})]
                          .asMap()
                          .entries
                          .map((e) {
                        if (e.key == _reels.length) {
                          return StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 1,
                              child: Opacity(
                                opacity: _isLoading ? 1 : 0,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ));
                        }
                        return StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 2,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ExploreListReelScreen(
                                          initpage: e.key,
                                          reels: _reels,
                                        )));
                              },
                              child: ImageHelper.loadImageNetWork(
                                  _reels[e.key].backgroundUrl!,
                                  fit: BoxFit.cover)),
                        );
                      }).toList()
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
