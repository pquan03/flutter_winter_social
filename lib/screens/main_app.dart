import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/models/notify.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/screens/add.dart';
import 'package:insta_node_app/screens/calling.dart';
import 'package:insta_node_app/screens/home.dart';
import 'package:insta_node_app/screens/keep_alive_screen.dart';
import 'package:insta_node_app/screens/profile.dart';
import 'package:insta_node_app/screens/reels.dart';
import 'package:insta_node_app/screens/search.dart';
import 'package:insta_node_app/utils/notifi_config.dart';
import 'package:insta_node_app/utils/socket_config.dart';
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
  void initState() {
    super.initState();
    SocketConfig.socket.on('createNotifyToClient', (data) {
      final newNotify = Notify.fromJson(data);
      NotificationService().showNotification(
        title: newNotify.user!.username!,
        body: newNotify.text!,
      );
    });

    SocketConfig.socket.on('callUserToClient', (data) {
      print(data);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CallingScreen(
                data: data,
              )));
    });
  }

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

  void handleNaviAddPost() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context).auth;
    return Scaffold(
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
                width: 1,
              ),
            ),
          ),
          child: CurvedNavigationBar(
            animationDuration: const Duration(milliseconds: 300),
            height: 70,
            index: _currentIndex,
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            buttonBackgroundColor: Theme.of(context).colorScheme.primary,
            letIndexChange: (value) {
              if (value == 2) {
                handleNaviAddPost();
                return false;
              }
              return true;
            },
            onTap: navigationTapped,
            items: [
              iconWidget(0, Icons.home, Icons.home_outlined),
              iconWidget(1, Icons.search, Icons.search_outlined),
              iconWidget(2, Icons.add_box, Icons.add_box_outlined),
              iconWidget(3, Icons.movie_filter, Icons.movie_filter_outlined),
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(auth.user!.avatar!),
                  radius: 12,
                ),
              ),
            ],
          )),
    );
  }

  List<Widget> _screens(Auth auth) => [
        KeepAlivePage(
            child: HomeScreen(
          accessToken: auth.accessToken!,
        )),
        KeepAlivePage(
            child: SearchScreen(
          accessToken: auth.accessToken!,
        )),
        Container(),
        ReelsScreen(),
        KeepAlivePage(
          child: ProfileScreen(
            token: auth.accessToken!,
            userId: auth.user!.sId!,
          ),
        ),
      ];

  Widget iconWidget(int index, IconData iconActive, IconData iconInactive) {
    return Icon(
      index == _currentIndex ? iconActive : iconInactive,
      color: Theme.of(context).colorScheme.secondary,
    );
  }
}
