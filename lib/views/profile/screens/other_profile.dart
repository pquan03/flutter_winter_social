import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/common_widgets/custom_back_button.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/models/user.dart' as model;
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/notifi_api.dart';
import 'package:insta_node_app/recources/reel_api.dart';
import 'package:insta_node_app/recources/user_api.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_state.dart';
import 'package:insta_node_app/views/message/screens/message.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/views/profile/widgets/list_post.dart';
import 'package:insta_node_app/views/profile/widgets/list_reel.dart';
import 'package:insta_node_app/views/profile/widgets/profile_user_info.dart';
import 'package:provider/provider.dart';

import '../../../constants/dimension.dart';

class OtherProfileScreen extends StatefulWidget {
  final String userId;
  const OtherProfileScreen({super.key, required this.userId});

  @override
  State<OtherProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<OtherProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int pagePost = 1;
  int pageReel = 1;
  bool _isLoading = false;
  bool _isLoadMore = true;
  List<Post> _posts = [];
  List<Reel> _reels = [];
  model.User user = model.User();
  int limit = 12;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getProfile();
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
  }

  void getProfile() async {
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    setState(() {
      _isLoading = true;
    });
    final res =
        await UserApi().getUserProfile(widget.userId, token, pagePost, limit);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      if (res['posts'].length % limit != 0 && res['posts'].isNotEmpty) {
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
    final auth = Provider.of<AuthProvider>(context, listen: false).auth;
    final res = await UserApi()
        .getPostProfile(widget.userId, auth.accessToken!, pagePost, limit);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _posts = [..._posts, ...res];
        pagePost++;
        _isLoading = false;
      });
    }
  }

  Future<void> getReelProfile() async {
    if (_reels.isNotEmpty && _reels.length % limit != 0) {
      setState(() {
        _isLoadMore = false;
      });
      return;
    }
    final auth = Provider.of<AuthProvider>(context, listen: false).auth;
    final res = await ReelApi()
        .getUserReel(widget.userId, auth.accessToken!, pageReel, limit);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _reels = [..._reels, ...res];
        pageReel++;
      });
    }
  }

  void handleFollowUser(Auth auth) async {
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    if (auth.user!.following!.contains(user.sId)) {
      final res = await UserApi().unFollowUser(user.sId!, token);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        if (!mounted) return;
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
        await NotifiApi()
            .deleteNotification(user.sId!, auth.user!.sId!, auth.accessToken!);
      }
    } else {
      final res = await UserApi().followUser(user.sId!, token);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        if (!mounted) return;
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
      final msg = {
        'text': 'started following you.',
        'recipients': [
          user.sId,
        ],
        'url': auth.user!.sId,
        'type': 'follow',
        'content': 'notification',
        'image': '',
        'user': {
          'sId': auth.user!.sId,
          'username': auth.user!.username,
          'avatar': auth.user!.avatar,
        },
      };
      await NotifiApi().createNotification(msg, auth.accessToken!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context).auth;
    return _isLoading
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
            ),
            body: Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            )),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              titleSpacing: 16,
              title: Row(
                children: [
                  CustomBackButton(size: 28),
                  const SizedBox(
                    width: 24,
                  ),
                  Text(
                    user.username!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            body: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileUserInfoWidget(user: user),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => handleFollowUser(auth),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Dimensions.dPaddingSmall),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: auth.user!.following!
                                                .contains(user.sId)
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primaryContainer
                                            : Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                        auth.user!.following!.contains(user.sId)
                                            ? 'Following'
                                            : 'Follow',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
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
                                  onTap: () {
                                    final stateChatBloc =
                                        BlocProvider.of<ChatBloc>(context,
                                                listen: false)
                                            .state;
                                    List<Messages> listMessage = [];
                                    if (stateChatBloc is ChatStateSuccess) {
                                      if (stateChatBloc
                                          .listConversation.isNotEmpty) {
                                        listMessage = [
                                          ...stateChatBloc.listConversation
                                              .where((element) {
                                                final listRecipientId = element
                                                    .recipients!
                                                    .map((e) => e.sId)
                                                    .toList();
                                                return listRecipientId
                                                        .contains(user.sId) &&
                                                    listRecipientId.contains(
                                                        auth.user!.sId);
                                              })
                                              .first
                                              .messages!
                                        ];
                                      }
                                    }
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => MessageScreen(
                                                user: UserPost.fromJson({
                                                  '_id': user.sId,
                                                  'username': user.username,
                                                  'avatar': user.avatar,
                                                  'fullname': user.fullname,
                                                }),
                                                firstListMessages:
                                                    listMessage)));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Dimensions.dPaddingSmall),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer
                                            .withOpacity(0.4),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text('Message',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  _posts.isEmpty && _reels.isEmpty
                      ? SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(),
                          ),
                        )
                      : SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: _SliverAppBarDelegate(
                            TabBar(
                              indicatorColor:
                                  Theme.of(context).colorScheme.secondary,
                              labelColor:
                                  Theme.of(context).colorScheme.secondary,
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
              body: _posts.isNotEmpty || _reels.isNotEmpty
                  ? TabBarView(
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
                    )
                  : Divider(),
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
