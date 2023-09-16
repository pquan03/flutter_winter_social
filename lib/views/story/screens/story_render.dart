import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:insta_node_app/models/story.dart';
import 'package:story_view/story_view.dart';

class StoryRenderScreen extends StatefulWidget {
  final Stories stories;
  final Function(int) naviTapped;
  final int currentPage;
  const StoryRenderScreen({super.key, required this.stories, required this.naviTapped, required this.currentPage});

  @override
  State<StoryRenderScreen> createState() => _StoryRenderScreenState();
}

class _StoryRenderScreenState extends State<StoryRenderScreen> {
  final StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.stories.stories!.isNotEmpty) {
      widget.stories.stories!.forEach((element) {
        if (element.media!.media.contains('video')) {
          storyItems.add(
            StoryItem.pageVideo(
              element.media!.media,
              controller: controller,
              duration:
                  Duration(milliseconds: ((element.media!.duration) * 1000).toInt()),
            ),
          );
        } else {
          storyItems.add(StoryItem.pageImage(
            url: element.media!.media,
            controller: controller,
            duration: Duration(
              milliseconds: (5 * 1000).toInt(),
            ),
          ));
        }
      });
      setState(() {
        storyItems = storyItems.reversed.toList();
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        // drag to pop
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Positioned.fill(
                      child: Hero(
                        tag: widget.stories.user!.avatar!,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: StoryView(
                            storyItems: storyItems,
                            controller: controller,
                            onComplete: () {
                              if(widget.currentPage == widget.stories.stories!.length - 1) {
                                Navigator.of(context).pop();
                              } else {
                                widget.naviTapped(widget.currentPage + 1);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 20,
                        left: 16,
                        right: 10,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(
                                widget.stories.user!.avatar!,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.stories.user!.username!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // Text(
                            //   convertTimeAgo(),
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontWeight: FontWeight.w400,
                            //     fontSize: 14,
                            //   ),
                            // ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.1,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        onTap: () {
                          
                        },
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
        ),
      ),
    );
  }
}
