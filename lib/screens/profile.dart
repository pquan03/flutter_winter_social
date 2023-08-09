import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/models/user.dart' as model;
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/user_api.dart';
import 'package:insta_node_app/screens/edit_profile.dart';
import 'package:insta_node_app/screens/explore_list_post.dart';
import 'package:insta_node_app/screens/follow_user.dart';
import 'package:insta_node_app/screens/preview.dart';
import 'package:insta_node_app/screens/settings.dart';
import 'package:insta_node_app/utils/animate_route.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/widgets/picker_crop_result_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String token;
  const ProfileScreen({super.key, required this.userId, required this.token});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isLoadMore = true;
  List<Post> _posts = [];
  int page = 1;
  int limit = 12;
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getPostProfile();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getPostProfile();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void getPostProfile() async {
    if (_posts.isNotEmpty && _posts.length % limit != 0) {
      print('no more');
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
    final res = await UserApi()
        .getPostProfile(widget.userId, widget.token, page, limit);
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
    final model.User user = Provider.of<AuthProvider>(context).auth.user!;
    return Scaffold(
        appBar: AppBar(
          title: Text(user.username!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          actions: [
            GestureDetector(
                onTap: () {
                  InstaAssetPicker.pickAssets(
                    context,
                    title: 'New post',
                    pickerTheme: InstaAssetPicker.themeData(
                            Theme.of(context).colorScheme.secondary)
                        .copyWith(
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                disabledForegroundColor: Colors.red,
                        ),
                      ),
                    ),
                    maxAssets: 5,
                    onCompleted: (cropStream) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PickerCropResultScreen(
                            cropStream: cropStream,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.add_box_outlined))),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.menu),
              ),
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                color: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                onRefresh: () async {
                  setState(() {
                    _posts = [];
                    page = 1;
                    _isLoadMore = true;
                  });
                  getPostProfile();
                },
                child: ListView(
                  shrinkWrap: true,
                  controller: _scrollController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(createRoute(
                                      PreviewScreen(
                                          imagesString: [user.avatar!])));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(user.avatar!),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(user.fullname!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      // scroll to center screen
                                      _scrollController.animateTo(
                                          MediaQuery.of(context).size.width / 2,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    },
                                    child: startColumnItem(
                                        user.countPosts!, 'Posts')),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => FollowUserScreen(
                                                  initIndex: 0,
                                                  username: user.username!,
                                                  followers: user.followers!,
                                                  following: user.following!,
                                                  accessToken: widget.token,
                                                )));
                                  },
                                  child: startColumnItem(
                                      user.followers!.length, 'Followers'),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => FollowUserScreen(
                                                  initIndex: 1,
                                                  username: user.username!,
                                                  followers: user.followers!,
                                                  following: user.following!,
                                                  accessToken: widget.token,
                                                )));
                                  },
                                  child: startColumnItem(
                                      user.following!.length, 'Following'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        user.story!,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => EditProfileScreen(
                                          user: user,
                                          onUpdateUser: handleUpdateUser,
                                        )));
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text('Edit Profile',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text('Share profile',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _posts.isEmpty
                        ? Container()
                        : DefaultTabController(
                            length: 2,
                            initialIndex: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 65,
                                  child: TabBar(
                                    // indicatorColor: Colors.white,
                                    onTap: (value) {
                                      setState(() {
                                        _currentIndex = value;
                                      });
                                    },
                                    tabs: const [
                                      Tab(
                                        icon: Icon(Icons.grid_on),
                                      ),
                                      Tab(
                                        icon: Icon(FontAwesomeIcons.film),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                IndexedStack(
                                  index: _currentIndex,
                                  children: [
                                    StaggeredGrid.count(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 2,
                                      children: [
                                        ...[
                                          ..._posts,
                                          ProfilePost.fromJson({
                                            '_id': '1',
                                            'image':
                                                'https://i.pinimg.com/originals/0f/6a/9e/0f6a9e2e2e2e2e2e2e2e2e2e2e2e2e2.jpg',
                                          })
                                        ].asMap().entries.map((e) {
                                          if (e.key == _posts.length) {
                                            return StaggeredGridTile.count(
                                                crossAxisCellCount: 3,
                                                mainAxisCellCount: 1,
                                                child: Opacity(
                                                  opacity: _isLoadMore ? 1 : 0,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                            color: Theme.of(context).colorScheme.secondary,
                                                          )),
                                                ));
                                          }
                                          return StaggeredGridTile.count(
                                            crossAxisCellCount: 1,
                                            mainAxisCellCount: 1,
                                            child: GestureDetector(
                                              onTap: () => Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (_) =>
                                                          ExploreListPostScreen(
                                                              title: 'Posts',
                                                              posts: _posts,
                                                              accessToken:
                                                                  widget
                                                                      .token))),
                                              child:
                                                  ImageHelper.loadImageNetWork(
                                                      _posts[e.key].images![0],
                                                      fit: BoxFit.cover),
                                            ),
                                          );
                                        }).toList()
                                      ],
                                    ),
                                    Center(
                                      child: Text(
                                        'No Reeels yet',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ));
  }

  Widget startColumnItem(int num, String title) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(num.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 8),
          Text(title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
