import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/models/story.dart';
import 'package:insta_node_app/views/story/widgets/animated_bar.dart';
import 'package:insta_node_app/views/story/widgets/user_info.dart';
import 'package:video_player/video_player.dart';

class WinterStoriesItem extends StatefulWidget {
  final Stories stories;
  final AnimationController animationController;
  final bool isPlayVideo;
  final Function? onParentoageChanged;
  const WinterStoriesItem({
    super.key,
    required this.stories,
    required this.animationController,
    required this.onParentoageChanged,
    this.isPlayVideo = true,
  });

  @override
  State<WinterStoriesItem> createState() => _WinterStoriesItemState();
}

class _WinterStoriesItemState extends State<WinterStoriesItem> {
  late PageController _pageController;
  VideoPlayerController? _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      final loadFirtStory = widget.stories.stories!.first;
      _loadStory(loadFirtStory, animateToPage: false);
    });
    widget.animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.animationController.stop();
        widget.animationController.reset();
        if (!mounted) return;
        setState(() {
          if (_currentPage + 1 < widget.stories.stories!.length) {
            _currentPage += 1;
            _loadStory(widget.stories.stories![_currentPage]);
          } else {
            widget.onParentoageChanged!();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    if (_videoPlayerController != null) {
      _videoPlayerController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories.stories![_currentPage];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: PageView.builder(
                    itemCount: widget.stories.stories!.length,
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final currentStory = widget.stories.stories![index];
                      return GestureDetector(
                        onTapDown: (details) => _onTapDown(details, story),
                        child: Builder(builder: (context) {
                          if (currentStory.media!.media.contains('video')) {
                            if (_videoPlayerController == null) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                ),
                              );
                            }
                            return FutureBuilder(
                              future: _initializeVideoPlayerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  _videoPlayerController!.play();
                                  widget.animationController.duration =
                                      _videoPlayerController!.value.duration;
                                  widget.animationController.forward();
                                  return AspectRatio(
                                    aspectRatio: _videoPlayerController!
                                        .value.aspectRatio,
                                    child: VideoPlayer(_videoPlayerController!),
                                  );
                                } else {
                                  _videoPlayerController!.pause();
                                  widget.animationController.stop();
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                    ),
                                  );
                                }
                              },
                            );
                          } else {
                            return ImageHelper.loadImageNetWork(
                              currentStory.media!.media,
                              fit: BoxFit.cover,
                            );
                          }
                        }),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 20.0,
                  left: 10.0,
                  right: 10.0,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: widget.stories.stories!.map((i) {
                          return AnimatedBar(
                            animController: widget.animationController,
                            position: widget.stories.stories!.indexOf(i),
                            currentIndex: _currentPage,
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 1.5,
                          vertical: 10.0,
                        ),
                        child: UserInfo(user: widget.stories.user!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.1,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Send message',
                      hintStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_outline,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _loadStory(Story story, {bool animateToPage = true}) {
    if (!mounted) return;
    widget.animationController.stop();
    widget.animationController.reset();
    switch (story.media!.media.contains('video')) {
      case false:
        _videoPlayerController?.pause();
        _videoPlayerController = null;
        widget.animationController.duration = Duration(seconds: 5);
        widget.animationController.forward();
        break;
      case true:
        _videoPlayerController?.pause();
        _videoPlayerController = null;
        _videoPlayerController?.dispose();
        _videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(story.media!.media));
        _initializeVideoPlayerFuture = _videoPlayerController!.initialize();
        break;
    }
    if (animateToPage) {
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentPage - 1 >= 0) {
          _currentPage -= 1;
          _loadStory(widget.stories.stories![_currentPage]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentPage + 1 < widget.stories.stories!.length) {
          _currentPage += 1;
          _loadStory(widget.stories.stories![_currentPage]);
        } else {
          // Out of bounds - loop story
          // You can also Navigator.of(context).pop() here
          _currentPage = 0;
          _loadStory(widget.stories.stories![_currentPage]);
        }
      });
    } else {
      if (story.media!.media.contains('video')) {
        if (_videoPlayerController!.value.isPlaying) {
          _videoPlayerController?.pause();
          widget.animationController.stop();
        } else {
          _videoPlayerController?.play();
          widget.animationController.forward();
        }
      }
    }
  }
}
