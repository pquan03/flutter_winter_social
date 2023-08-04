import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/screens/screens/home.dart';
import 'package:insta_node_app/screens/screens/keep_alive_screen.dart';
import 'package:insta_node_app/screens/screens/profile.dart';
import 'package:insta_node_app/screens/screens/reels.dart';
import 'package:insta_node_app/screens/screens/search.dart';
import 'package:insta_node_app/widgets/picker_crop_result_screen.dart';
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
          child: CurvedNavigationBar(
            animationDuration: const Duration(milliseconds: 300),
            height: 50,
            index: _currentIndex,
            color: Colors.black,
            backgroundColor: Colors.white,
            buttonBackgroundColor: Colors.black,
            letIndexChange: (value) {
              if (value == 2) {
                InstaAssetPicker.pickAssets(
                          context,
                          title: 'New post',
                          pickerTheme: InstaAssetPicker.themeData(
                                  Theme.of(context).primaryColor)
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
                    border: _currentIndex == 4
                        ? Border.all(color: Colors.white, width: 2)
                        : Border.all(color: Colors.transparent, width: 0)),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(auth.user!.avatar!),
                  radius: 16,
                ),
              ),
            ],
          )),
    ));
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
        ProfileScreen(),
      ];

  Widget iconWidget(int index, IconData iconActive, IconData iconInactive) {
    return Icon(
      index == _currentIndex ? iconActive : iconInactive,
      color: index == _currentIndex ? Colors.white : Colors.grey,
    );
  }
}
