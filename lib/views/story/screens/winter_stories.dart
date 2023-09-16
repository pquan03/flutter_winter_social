import 'package:flutter/material.dart';
import 'package:insta_node_app/models/story.dart';
import 'package:insta_node_app/views/story/widgets/winter_stories_item.dart';

class WinterStoriesPage extends StatefulWidget {
  final List<Stories> listStories;
  final int initPage;
  const WinterStoriesPage(
      {super.key, required this.listStories, required this.initPage});

  @override
  State<WinterStoriesPage> createState() => _WinterStoriesPageState();
}

class _WinterStoriesPageState extends State<WinterStoriesPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initPage);
    _animationController = AnimationController(vsync: this);

    _pageController.addListener(() {
      // when user keep scrolling, stop the animation
      _animationController.stop();
      if (_pageController.page! % 1 == 0) {
        _animationController.reset();
        _animationController.forward();
      } else {
        _animationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void handleChangePage() {
    if(_pageController.page! + 1 < widget.listStories.length) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.listStories.length,
          controller: _pageController,
          itemBuilder: (context, index) {
            return WinterStoriesItem(
              stories: widget.listStories[index],
              animationController: _animationController,
              onParentoageChanged: handleChangePage,
            );
          },
        ),
    );
  }
}
