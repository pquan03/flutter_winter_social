import 'package:flutter/material.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/models/user.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/user_api.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:insta_node_app/views/profile/screens/other_profile.dart';
import 'package:provider/provider.dart';

class LikesPostScreen extends StatefulWidget {
  final List<String> likes;
  const LikesPostScreen({super.key, required this.likes});

  @override
  State<LikesPostScreen> createState() => _LikesPostScreenState();
}

class _LikesPostScreenState extends State<LikesPostScreen> {
  List<UserPost> _userLikes = [];
  bool _isLoading = true;
  late TextEditingController _searchController;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 400), () {
      handleGetUserLikes();
    });
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final currentUser = Provider.of<AuthProvider>(context).auth.user!;
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                ),
                Text('Likes',
                    style: TextStyle(fontSize: 20, color: Colors.black)),
              ],
            )),
        body: Container(
            padding: const EdgeInsets.all(12),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.blue,
                  ))
                : _userLikes.isEmpty
                    ? Center(
                        child: Text('No likes'),
                      )
                    : Column(
                        children: [
                          TextField(
                            controller: _searchController,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[350],
                              contentPadding: EdgeInsets.all(8),
                              isDense: true,
                              hintText: 'Search',
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 25,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _userLikes.length,
                              itemBuilder: (context, index) {
                                final user = _userLikes[index];
                                return buildUserCard(user, currentUser, token);
                              },
                            ),
                          ),
                        ],
                      )));
  }

  ListTile buildUserCard(UserPost user, User currentUser, String token) {
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => OtherProfileScreen(
                userId: user.sId!,
              ))),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.avatar!),
      ),
      title: Text(user.username!),
      subtitle: Text(user.fullname!),
      trailing: currentUser.sId == user.sId
          ? null
          : currentUser.followers!.contains(user.sId!)
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[350],
                  ),
                  onPressed: () async {
                    final res = await UserApi().unFollowUser(user.sId!, token);
                    if (res is String) {
                      if (!mounted) return;
                      showSnackBar(context, 'Error', res);
                    } else {
                      setState(() {
                        _userLikes
                            .removeWhere((element) => element.sId == user.sId);
                      });
                    }
                  },
                  child: Text(
                    'Following',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[350],
                  ),
                  onPressed: () async {
                    final res = await UserApi().followUser(user.sId!, token);
                    if (res is String) {
                      if (!mounted) return;
                      showSnackBar(context, 'Error', res);
                    } else {
                      setState(() {
                        _userLikes
                            .removeWhere((element) => element.sId == user.sId);
                      });
                    }
                  },
                  child: Text(
                    'Follow',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
    );
  }

  void handleGetUserLikes() async {
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final res = await UserApi().getInfoListFollow(widget.likes, token);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _userLikes = [..._userLikes, ...res];
        _isLoading = false;
      });
    }
  }
}
