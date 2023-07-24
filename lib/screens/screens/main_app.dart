import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/screens/screens/add_post.dart';
import 'package:insta_node_app/screens/screens/home.dart';
import 'package:insta_node_app/screens/screens/keep_alive_screen.dart';
import 'package:insta_node_app/screens/screens/profile.dart';
import 'package:insta_node_app/screens/screens/reels.dart';
import 'package:insta_node_app/screens/screens/search.dart';
import 'package:provider/provider.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context).auth;
    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: <Widget>[..._screens(auth).map((e) => e).toList()],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
          ),
          child: CupertinoTabBar(
            backgroundColor: Colors.black,
            activeColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: navigationTapped,
            items: [
              ActiveBottomNavigationBarItem(
                  0, Icon(Icons.home), Icon(Icons.home_outlined)),
              ActiveBottomNavigationBarItem(
                  1, Icon(Icons.search), Icon(Icons.search_outlined)),
              ActiveBottomNavigationBarItem(
                  2, Icon(Icons.add_box), Icon(Icons.add_box_outlined)),
              ActiveBottomNavigationBarItem(
                  3, Icon(Icons.movie_filter), Icon(Icons.movie_filter_outlined)),
              ActiveBottomNavigationBarItem(
                  4,
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2)),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(auth.user!.avatar!),
                      radius: 16,
                    ),
                  ),
                  CircleAvatar(
                      backgroundImage: NetworkImage(auth.user!.avatar!),
                      radius: 16,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }


  List<Widget> _screens (Auth auth) => [
    KeepAlivePage(child: HomeScreen(accessToken: auth.accessToken!,)),
    SearchScreen(),
    AddPostScreen(),
    ReelsScreen(),
    ProfileScreen(),
  ];

  BottomNavigationBarItem ActiveBottomNavigationBarItem(
      int index, Widget iconActive, Widget iconInactive) {
    return BottomNavigationBarItem(
      icon: _currentIndex == index ? iconActive : iconInactive,
      // label: label,
      backgroundColor: _currentIndex == index ? Colors.black : Colors.grey,
    );
  }
}
