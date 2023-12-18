import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_event.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:insta_node_app/utils/helpers/image_helper.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/models/story.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/message_api.dart';
import 'package:insta_node_app/views/story/widgets/animated_bar.dart';
import 'package:insta_node_app/views/story/widgets/user_info.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../bloc/chat_bloc/chat_bloc.dart';
import '../../../bloc/chat_bloc/chat_state.dart';
import '../../../models/conversation.dart';
import '../../../recources/story_api.dart';

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
  late TextEditingController _textEditingController;
  VideoPlayerController? _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _textEditingController = TextEditingController();

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
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories.stories![_currentPage];
    final user = Provider.of<AuthProvider>(context).auth.user!;
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      print(isKeyboardVisible);
      // if (isKeyboardVisible) {
      //   widget.animationController.stop();
      //   _videoPlayerController?.pause();
      // } else {
      //   _videoPlayerController?.play();
      //   if (widget.animationController.duration != null) {
      //     widget.animationController.forward();
      //   }
      // }
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
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return FutureBuilder(
                                future: _initializeVideoPlayerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    widget.animationController.duration =
                                        _videoPlayerController!.value.duration;
                                    widget.animationController.forward();
                                    _videoPlayerController?.play();
                                    return AspectRatio(
                                      aspectRatio: _videoPlayerController!
                                          .value.aspectRatio,
                                      child:
                                          VideoPlayer(_videoPlayerController!),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: UserInfo(
                            user: widget.stories.user!,
                            storyId: story.sId!,
                            handleDeleteStory: handleDeleteStory,
                            createdAt: widget
                                .stories.stories![_currentPage].createdAt!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (user.sId != widget.stories.user!.sId)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        style: TextStyle(color: Colors.white),
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
                    _textEditingController.text == ''
                        ? IconButton(
                            onPressed: () {
                              _textEditingController.text += '🙂';
                              handleCreateMessage(widget.stories.user!);
                            },
                            icon: Icon(
                              Icons.favorite_outline,
                              color: Colors.white,
                              size: 25,
                            ),
                          )
                        : SizedBox.shrink(),
                    IconButton(
                      onPressed: () =>
                          handleCreateMessage(widget.stories.user!),
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
    });
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
        setState(() {});
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

  void handleDeleteStory(String storyId, String token) async {
    final res = await StoryApi().deleteStory(storyId, token);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        widget.stories.stories!.removeAt(_currentPage);
      });
    }
  }

  final List<String> listIcon = [
    "🙂",
    "😀",
    "😄",
    "😆",
    "😅",
    "😂",
  ];

  void handleCreateMessage(UserPost user) async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final currentUser =
        Provider.of<AuthProvider>(context, listen: false).auth.user!;
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final state = chatBloc.state;
    if (state is ChatStateSuccess) {
      final listConversation = state.listConversation;
      final currentConversation = listConversation.firstWhere((element) {
        final listUser = element.recipients!.map((e) => e.sId).toList();
        if (listUser.contains(currentUser.sId) && listUser.contains(user.sId)) {
          return true;
        } else {
          return false;
        }
      }, orElse: () {
        return Conversations();
      });
      final message = {
        'conversationId': currentConversation.sId ?? user.sId,
        'avatar': currentUser.avatar,
        'username': currentUser.username,
        'text': _textEditingController.text,
        'linkStory': widget.stories.stories![_currentPage],
        'senderId': currentUser.sId,
        'recipientId': user.sId,
        'media': [],
        'call': null
      };
      _textEditingController.text = '';
      final res = await MessageApi().createMessageText(message, accessToken);
      if (res is String) {
        if (!mounted) return;
        showSnackBar(context, 'Error', res);
      } else {
        if (!mounted) return;
        showSnackBar(context, 'Success', 'Send message success');
        final chatBloc = BlocProvider.of<ChatBloc>(context);
        chatBloc.add(ChatEventAddMessage(
            conversation: Conversations.fromJson(res['conversation']),
            message: Messages.fromJson(res['message'])));
      }
    }
  }
}
