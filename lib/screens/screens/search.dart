import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/recources/post_api.dart';
import 'package:insta_node_app/recources/user_api.dart';
import 'package:insta_node_app/screens/screens/other_profile.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';

class SearchScreen extends StatefulWidget {
  final String accessToken;
  const SearchScreen({super.key, required this.accessToken});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;
  bool _isLoadingShimmer = false;
  List<ProfilePost> _posts = [];
  List<UserPost> users = [];
  bool _isSearch = false;
  bool _isLoadMore = true;
  static int page = 1;
  static const int limit = 15;

  @override
  void initState() {
    super.initState();
    getPostDiscover();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getPostDiscover();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _scrollController.dispose();
  }

  void getPostDiscover() async {
    if (_posts.isNotEmpty && _posts.length % limit != 0) {
      setState(() {
        _isLoadMore = false;
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final res =
        await PostApi().getPostDiscover(widget.accessToken, page, limit);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            children: [
              _isSearch
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSearch = false;
                          _searchController.clear();
                          users = [];
                          _focusNode.unfocus();
                        });
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  : Container(),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: AppBar().preferredSize.height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: (value) async {
                      setState(() {
                        users = [];
                      });
                      if (value != '') {
                        setState(() {
                          _isLoadingShimmer = true;
                        });
                        final res = await UserApi()
                            .searchUser(value, widget.accessToken);
                        if (res is String) {
                          if (!mounted) return;
                          showSnackBar(context, 'Error', res);
                        } else {
                          setState(() {
                            users = [...res];
                            _isLoadingShimmer = false;
                          });
                        }
                      } else {
                        setState(() {
                          users = [];
                        });
                      }
                    },
                    onTap: () {
                      setState(() {
                        _isSearch = true;
                      });
                    },
                    controller: _searchController,
                    autofocus: false,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      suffixIcon: _searchController.text != ''
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  users = [];
                                  _searchController.text = '';
                                });
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : null,
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: !_isSearch
            ? _isLoading
                ? SingleChildScrollView(
                  child: StaggeredGrid.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      children: [
                        ...List.generate(15, (index) {
                          if (index == 0 ||
                              index == 7 ||
                              (index >= 10 &&
                                  (index % 10 == 0 || index % 10 == 6))) {
                            return StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 2,
                              child: Container(
                                color: Colors.grey,
                              ),
                            );
                          } 
                          return StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Container(
                              color: Colors.grey,
                            ),
                          );
                        })
                      ],
                    ),
                )
                : RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _posts = [];
                        page = 1;
                        
                      });
                      getPostDiscover();
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                  child: StaggeredGrid.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      children: [...[..._posts, ProfilePost.fromJson({
                        '_id': '1',
                        'image': 'https://i.pinimg.com/originals/0f/6a/9e/0f6a9e2e2e2e2e2e2e2e2e2e2e2e2e2.jpg',
                      })].asMap().entries.map((e) {
                        if(e.key == 0 ||
                              e.key == 7 ||
                              (e.key >= 10 &&
                                  (e.key % 10 == 0 || e.key % 10 == 6))) {
                            return StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 2,
                              child: ImageHelper.loadImageNetWork(_posts[e.key].image!, fit: BoxFit.cover),
                            );
                          } else if(e.key == _posts.length) {
                            return StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 1,
                              child: Opacity(
                                opacity: _isLoadMore ? 1  : 0,
                                child: Center(
                                  child: CircularProgressIndicator(color: Colors.white, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
                              )
                            );
                          }
                          return StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: ImageHelper.loadImageNetWork(_posts[e.key].image!, fit: BoxFit.cover),
                          );
                      }).toList()],
                    ),
                ),
                  )
            : _isLoadingShimmer
                ? LoadingShimmer(
                    child: ListView(children: <Widget>[
                      ...List.generate(
                        2,
                        (index) => buildTempUser(),
                      ),
                    ]),
                  )
                : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => OtherProfileScreen(userId: users[index].sId!, token: widget.accessToken,)));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(users[index].avatar!),
                          ),
                          title: Text(
                            users[index].username!,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            users[index].fullname!,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    },
                  ));
  }

  Widget buildTempUser() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.5,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 100,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
