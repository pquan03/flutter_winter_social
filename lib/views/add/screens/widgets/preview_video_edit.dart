import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insta_node_app/views/add/screens/add_reel/add_reel_caption.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PreviewEditVideoScreen extends StatefulWidget {
  final File videoFile;
  const PreviewEditVideoScreen({super.key, required this.videoFile});

  @override
  State<PreviewEditVideoScreen> createState() => _PreviewEditVideoScreenState();
}

class _PreviewEditVideoScreenState extends State<PreviewEditVideoScreen> {
  late VideoPlayerController _videoController;
  final _boundaryKey = GlobalKey();
  bool _isLoading = false;

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

  Future<void> captureFrameAndSave() async {
    setState(() {
      _isLoading = true;
    });
    final boundary = _boundaryKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AddReelCaptionScreen(
              reelFile: widget.videoFile,
              backgroundImage: buffer,
            )));
    // Now you have saved the captured frame as an image in the filePath
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
                  child: VisibilityDetector(
                      key: Key("unique key"),
                      onVisibilityChanged: (VisibilityInfo info) {
                        if (!mounted) return;
                        if (info.visibleFraction == 1) {
                          if (info.visibleFraction == 0) {
                            _videoController.pause();
                          } else {
                            _videoController.play();
                          }
                        } else {
                          if (info.visibleFraction == 1) {
                            _videoController.play();
                          } else {
                            _videoController.pause();
                          }
                        }
                      },
                      child: RepaintBoundary(
                          key: _boundaryKey,
                          child: VideoPlayer(_videoController))))),
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
                  // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (_) => AddReelCaptionScreen(
                  //           reelFile: widget.videoFile,
                  //         ))),
                  onTap: captureFrameAndSave,
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(20)),
                    child: _isLoading ? Center(child: CircularProgressIndicator()) :  Row(
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
