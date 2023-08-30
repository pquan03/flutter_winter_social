import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/models/user.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/reel_api.dart';
import 'package:insta_node_app/recources/user_api.dart';
import 'package:insta_node_app/views/add/screens/add_post/media_gallery_post.dart';
import 'package:insta_node_app/views/post/screens/explore_list_post.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/views/profile/screens/follow_user.dart';
import 'package:insta_node_app/views/profile/widgets/choose_account_modal.dart';
import 'package:insta_node_app/views/profile/widgets/edit_profile.dart';
import 'package:insta_node_app/views/reel/screens/explore_list_reel.dart';
import 'package:insta_node_app/views/setting/screens/settings.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isLoadMore = true;
  List<Post> _posts = [];
  List<Reel> _reels = [];
  int page = 1;
  int limit = 12;
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getPostProfile();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('load more');
        getPostProfile();
      }
    });
    _tabController.addListener(() {
      print('haha');
      if (_tabController.index == 1 && _reels.isEmpty) {
        getReelProfile();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }

  void getReelProfile() async {
    if (_reels.isNotEmpty && _reels.length % limit != 0) {
      setState(() {
        _isLoadMore = false;
      });
      return;
    }
    if (_reels.isEmpty) {
      setState(() {
        _isLoading = true;
      });
    }
    final auth = Provider.of<AuthProvider>(context, listen: false).auth;
    final res = await ReelApi()
        .getUserReel(auth.user!.sId!, auth.accessToken!, page, limit);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _reels = [..._reels, ...res];
        _isLoading = false;
      });
    }
  }

  void getPostProfile() async {
    if (_posts.isNotEmpty && _posts.length % limit != 0) {
      setState(() {
        _isLoadMore = false;
      });
      return;
    }
    if (_posts.isEmpty) {
      setState(() {
        _isLoading = true;
      });
    }
    final auth = Provider.of<AuthProvider>(context, listen: false).auth;
    final res = await UserApi()
        .getPostProfile(auth.user!.sId!, auth.accessToken!, page, limit);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _posts = [..._posts, ...res];
        page++;
        _isLoading = false;
      });
    }
  }

  void handleUpdateUser(Map<String, dynamic> data) async {
    final res =
        await UserApi().updateUser(data['user']!, data['access_token']!);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      if (!mounted) return;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAuth(Auth.fromJson(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    final accessToken = Provider.of<AuthProvider>(context).auth.accessToken;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: InkWell(
          onTap: () =>
              showModalBottomSheetCustom(context, ChooseAccountModalWidget()),
          child: Row(
            children: [
              Text(
                user.username!,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 12,
              ),
              Icon(
                Icons.keyboard_arrow_down,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => MediaGalleryPostScreen()));
            },
            icon: const Icon(
              Icons.add_box_outlined,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SettingsScreen()));
            },
            icon: const Icon(
              Icons.menu,
              size: 28,
            ),
          ),
        ],
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    profileInfoUser(user),
                    const SizedBox(height: 8),
                    Text(
                      user.fullname!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.story!,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.website!,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (!mounted) return;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => EditProfileScreen(
                                      user: user,
                                      onUpdateUser: handleUpdateUser)));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[350],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side:
                                    const BorderSide(color: Colors.transparent),
                              ),
                            ),
                            child: const Text(
                              'Edit profile',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[350],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side:
                                    const BorderSide(color: Colors.transparent),
                              ),
                            ),
                            child: const Text('Share profile',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  labelColor: Theme.of(context).colorScheme.secondary,
                  unselectedLabelColor: Colors.grey[400],
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.grid_on),
                    ),
                    Tab(
                      icon: Icon(Icons.movie_filter),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // tab 1
            Builder(builder: (context) {
              return _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ))
                  : _posts.isEmpty
                      ? Center(
                          child: Text(
                            'No Post',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // controller: _scrollController,
                  child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: [
                      ...[..._posts, {}]
                          .asMap()
                          .entries
                          .map((e) {
                        if (e.key == _posts.length) {
                          return StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 1,
                              child: Opacity(
                                opacity: _isLoadMore ? 1 : 0,
                                child:
                                    Center(child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    )),
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
                                        posts: newListPost,
                                        title: 'Posts',
                                        )));
                              },
                              child: ImageHelper.loadImageNetWork(
                                  _posts[e.key].images![0],
                                  fit: BoxFit.cover)
                                  ),
                        );
                      }).toList()
                    ],
                  ),
                );
            }),
            // tab 2
            Builder(builder: (context) {
              return _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ))
                  : _reels.isEmpty
                      ? Center(
                          child: Text(
                            'No Reels',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // controller: _scrollController,
                  child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: [
                      ...[..._reels, {}]
                          .asMap()
                          .entries
                          .map((e) {
                        if (e.key == _reels.length) {
                          return StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 1,
                              child: Opacity(
                                opacity: _isLoadMore ? 1 : 0,
                                child:
                                    Center(child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    )),
                              ));
                        }
                        return StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 2,
                          child: GestureDetector(
                              onTap: () {
                                final newListPost = [..._reels];
                                final tempPost = newListPost[e.key];
                                newListPost.removeAt(e.key);
                                newListPost.insert(0, tempPost);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ExploreListReelScreen(
                                        reels: newListPost,
                                        accessToken: accessToken!)));
                              },
                              child: ImageHelper.loadImageNetWork(
                                  _reels[e.key].backgroundUrl!,
                                  fit: BoxFit.cover)
                                  ),
                        );
                      }).toList()
                    ],
                  ),
                );
            }),
          ],
        ),
      ),
    );
  }

  Widget profileInfoUser(User user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImageHelper.loadImageNetWork(user.avatar!,
            borderRadius: BorderRadius.circular(50),
            fit: BoxFit.cover,
            height: 72,
            width: 72),
        const SizedBox(width: 24),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              startColumnItem(user.countPosts!, 'Posts', () {
                _scrollController.animateTo(150,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              }),
              startColumnItem(user.followers!.length, 'Followers', () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => FollowUserScreen(initIndex: 0, username: user.username!, followers: user.followers!, following: user.following!)));
              }),
              startColumnItem(user.following!.length, 'Following', () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => FollowUserScreen(initIndex: 1, username: user.username!, followers: user.followers!, following: user.following!)));
              }),
            ],
          ),
        )
      ],
    );
  }

  Widget startColumnItem(int number, String title, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              number.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final TabBar _tabBar;
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
