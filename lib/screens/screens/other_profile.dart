import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/models/user.dart' as model;
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/user_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:provider/provider.dart';

class OtherProfileScreen extends StatefulWidget {
  final String userId;
  final String token;
  const OtherProfileScreen(
      {super.key, required this.userId, required this.token});

  @override
  State<OtherProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<OtherProfileScreen>
    with TickerProviderStateMixin {
  static int page = 1;
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _isLoadMore = true;
  List<ProfilePost> _posts = [];
  model.User user = model.User();
  static const int limit = 12;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getProfile();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getPostProfile();
      } else {
        
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void getProfile() async {
    setState(() {
      _isLoading = true;
    });
    final res = await UserApi().getUserProfile(widget.userId, widget.token, page, limit);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      if(res['posts'].length % limit != 0 && res['posts'].isNotEmpty) {
        setState(() {
          _isLoadMore = false;
        });
      }
      setState(() {
        user = res['user'];
        _posts = [...res['posts']];
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

  void handleFollowUser(Auth auth) async {
    if(auth.user!.following!.contains(user.sId)) {
      final res = await UserApi().unFollowUser(user.sId!, widget.token);
      if(res is String) {
        if(!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        if(!mounted) return;
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.setAuth(Auth.fromJson({
          ...auth.toJson(),
          'user': {
            ...auth.user!.toJson(),
            'following': [...auth.user!.following!]..remove(user.sId)
          }
        }));
        setState(() {
          user.followers!.removeWhere((element) => element == auth.user!.sId);
        });
      }
    } else {
      final res = await UserApi().followUser(user.sId!, widget.token);
      if(res is String) {
        if(!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        if(!mounted) return;
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.setAuth(Auth.fromJson({
          ...auth.toJson(),
          'user': {
            ...auth.user!.toJson(),
            'following': [...auth.user!.following!, user.sId]
          }
        }));
        setState(() {
          user.followers!.add(auth.user!.sId!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<AuthProvider>(context).auth;
    return _isLoading
        ? Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.grey[900],
            ),
            body: Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: Colors.grey[900],
              title: Text(user.username!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                getPostProfile();
              },
              child: ListView(
                controller: _scrollController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(user.avatar!),
                            ),
                            const SizedBox(height: 8),
                            Text(user.fullname!,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              startColumnItem(0, 'Posts'),
                              Spacer(),
                              startColumnItem(
                                  user.followers!.length, 'Followers'),
                              Spacer(),
                              startColumnItem(
                                  user.following!.length, 'Following'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      user.story!,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => handleFollowUser(auth),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: auth.user!.following!.contains(user.sId) ? HexColor('#121212') : Colors.blue,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(auth.user!.following!.contains(user.sId) ? 'Following' :'Follow',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
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
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: HexColor('#121212'),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text('Message',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
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
                                  indicatorColor: Colors.white,
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
                                                    child: CircularProgressIndicator(
                                                        color: Colors.white,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.white))),
                                              ));
                                        }
                                        return StaggeredGridTile.count(
                                          crossAxisCellCount: 1,
                                          mainAxisCellCount: 1,
                                          child: ImageHelper.loadImageNetWork(
                                              _posts[e.key].image!,
                                              fit: BoxFit.cover),
                                        );
                                      }).toList()
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      'No Reeels yet',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
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

  Column startColumnItem(int num, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(num.toString(),
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 8),
        Text(title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }
}
