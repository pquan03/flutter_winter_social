import 'package:flutter/material.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/recources/user_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/widgets/user_card.dart';

class FollowUserScreen extends StatefulWidget {
  final int initIndex;
  final String username;
  final List<String> followers;
  final List<String> following;
  final String accessToken;
  const FollowUserScreen(
      {super.key,
      required this.initIndex,
      required this.username,
      required this.followers,
      required this.following,
      required this.accessToken});

  @override
  State<FollowUserScreen> createState() => _FollowUserScreenState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _FollowUserScreenState extends State<FollowUserScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  bool _isLoading = false;
  List<UserPost> _userFollowers = [];
  List<UserPost> _userFollowing = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initIndex);
    getListInfo();
    _tabController.addListener(() {
      if(_tabController.index != widget.initIndex && (_userFollowers.isEmpty || _userFollowing.isEmpty)) {
        getListInfo();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void getListInfo() async {
    setState(() {
      _isLoading = true;
    });
    if(_tabController.index == 0)  {
      final res = await UserApi().getInfoListFollow(widget.followers, widget.accessToken);
      if(res is List) {
        setState(() {
          _userFollowers = [...res];
        });
      } else {
        if(!mounted) return;
        showSnackBar(context, 'Error', res);
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      final res = await UserApi().getInfoListFollow(widget.following, widget.accessToken);
      if(res is List) {
        setState(() {
          _userFollowing = [...res];
        });
      } else {
        if(!mounted) return;
        showSnackBar(context, 'Error', res);
      }
      setState(() {
        _isLoading = false;
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
              widget.username,
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
          tabs: <Widget>[
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.followers.length.toString(), style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),
                  const SizedBox(width: 8,),
                  Text('Followers', style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.following.length.toString(), style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),
                  const SizedBox(width: 8,),
                  Text('Following', style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _isLoading ? Center(child: CircularProgressIndicator(),) :
          ListView.builder(
            itemCount: _userFollowers.length,
            itemBuilder: (context, index) {
              return UserCardWidget(user: _userFollowers[index]);
            },
          ),
          _isLoading ? Center(child: CircularProgressIndicator(),) :
          ListView.builder(
            itemCount: _userFollowing.length,
            itemBuilder: (context, index) {
              return UserCardWidget(user: _userFollowing[index]);
            },
          ),
        ],
      ),
    );
  }
}
