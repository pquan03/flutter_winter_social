import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_node_app/screens/add_reel_caption.dart';
import 'package:video_player/video_player.dart';

class PreviewEditVideoScreen extends StatefulWidget {
  final File videoFile;
  const PreviewEditVideoScreen({super.key, required this.videoFile});

  @override
  State<PreviewEditVideoScreen> createState() => _PreviewEditVideoScreenState();
}

class _PreviewEditVideoScreenState extends State<PreviewEditVideoScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(widget.videoFile);
    _videoController.initialize();
    _videoController.play();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            )),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
                onTap: () {
                  if (_videoController.value.isPlaying) {
                    _videoController.pause();
                  } else {
                    _videoController.play();
                  }
                },
                child: VideoPlayer(_videoController)),
          ),
          VideoProgressIndicator(
            _videoController,
            allowScrubbing: true,
            padding: const EdgeInsets.all(2),
            colors: VideoProgressColors(
              playedColor: Colors.white,
              backgroundColor: Colors.white.withOpacity(0.5),
              bufferedColor: Colors.black,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddReelCaptionScreen(reelFile: widget.videoFile,))),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: const [
                        Text(
                          'Next',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
