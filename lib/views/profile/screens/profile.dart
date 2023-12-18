import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/constants/size.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/reel_api.dart';
import 'package:insta_node_app/recources/user_api.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:insta_node_app/views/add/screens/add_post/media_gallery_post.dart';
import 'package:insta_node_app/views/profile/widgets/choose_account_modal.dart';
import 'package:insta_node_app/views/profile/widgets/edit_profile.dart';
import 'package:insta_node_app/views/profile/widgets/list_post.dart';
import 'package:insta_node_app/views/profile/widgets/list_reel.dart';
import 'package:insta_node_app/views/profile/widgets/profile_user_info.dart';
import 'package:insta_node_app/views/setting/screens/settings.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _isLoadMore = false;
  List<Post> _posts = [];
  List<Reel> _reels = [];
  final ScrollController _scrollController = ScrollController();
  int limit = 12;
  int pagePost = 1;
  int pageReel = 1;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getPostProfile();
    _tabController.addListener(() {
      if (_reels.isEmpty && _tabController.index == 1) {
        getReelProfile();
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_tabController.index == 0) {
          getPostProfile();
        } else {
          getReelProfile();
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _tabController.dispose();
  }

  void getPostProfile() async {
    setState(() {
      _isLoadMore = true;
    });
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
        .getPostProfile(auth.user!.sId!, auth.accessToken!, pagePost, limit);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _posts = [..._posts, ...res];
        pagePost++;
        _isLoading = false;
        _isLoadMore = false;
      });
    }
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
        .getUserReel(auth.user!.sId!, auth.accessToken!, pageReel, limit);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _reels = [..._reels, ...res];
        pageReel++;
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
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: GestureDetector(
          onTap: () =>
              showModalBottomSheetCustom(context, ChooseAccountModalWidget()),
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Text(
                  user.username!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                    ProfileUserInfoWidget(
                      user: user,
                      scrollController: _scrollController,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: dark
                                    ? Colors.white.withOpacity(.1)
                                    : Colors.black.withOpacity(.1)),
                            child: IconButton(
                              onPressed: () {
                                if (!mounted) return;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => EditProfileScreen(
                                        user: user,
                                        onUpdateUser: handleUpdateUser)));
                              },
                              icon: Text(
                                "Edit profile",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: dark
                                    ? Colors.white.withOpacity(.1)
                                    : Colors.black.withOpacity(.1)),
                            child: IconButton(
                              onPressed: () {},
                              icon: Text(
                                "Share profile",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            if (_posts.isNotEmpty || _reels.isNotEmpty)
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 1,
                    indicatorColor: dark ? Colors.white : Colors.black,
                    labelColor: dark ? Colors.white : Colors.black,
                    unselectedLabelColor: Colors.grey.withOpacity(.2),
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
        body: _posts.isEmpty && _reels.isEmpty
            ? Container()
            : TabBarView(
                controller: _tabController,
                children: [
                  // tab 1
                  ListPostProfileWiget(
                    isLoadMore: _isLoadMore,
                    isLoading: _isLoading,
                    posts: _posts,
                  ),
                  // tab 2
                  ListReelProfileWidget(
                    isLoadMore: _isLoadMore,
                    isLoading: _isLoading,
                    reels: _reels,
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
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
