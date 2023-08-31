import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/models/story.dart';
import 'package:insta_node_app/views/reel/widgets/video_card.dart';
import 'package:video_player/video_player.dart';

class StoryScreen extends StatefulWidget {
  final Story story;
  const StoryScreen({super.key, required this.story});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                      child: CarouselSlider(
                    items: widget.story.media!
                        .map((e) => e.contains('video')
                            ? Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Positioned.fill(
                                      child: VideoCardWidget(videoUrl: e,)),
                                ],
                              )
                            : ImageHelper.loadImageNetWork(e,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )))
                        .toList(),
                    options: CarouselOptions(
                      height: double.infinity,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                      initialPage: 0,
                      reverse: false,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: false,
                      scrollDirection: Axis.horizontal,
                    ),
                  )),
                  Positioned(
                      top: 5,
                      left: 16,
                      right: 10,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(
                              widget.story.user!.avatar!,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.story.user!.username!,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '1h',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
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
      ),
    );
  }
}
