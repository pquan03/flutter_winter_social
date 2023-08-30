import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoCardWidget extends StatefulWidget {
  final File? videoFile;
  final String? videoUrl;
  final String? backgroundUrl;
  const VideoCardWidget(
      {super.key, this.videoFile, this.videoUrl, this.backgroundUrl});

  @override
  State<VideoCardWidget> createState() => _VideoCardWidgetState();
}

class _VideoCardWidgetState extends State<VideoCardWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.videoFile != null) {
      _controller = VideoPlayerController.file(widget.videoFile!);
    } else {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
    }
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GestureDetector(
                  onTap: () => _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play(),
                  child: Container(
                      width: size.width,
                      height: size.height,
                      decoration: BoxDecoration(color: Colors.black),
                      child: VisibilityDetector(
                        key: Key("unique key"),
                        onVisibilityChanged: (VisibilityInfo info) {
                          debugPrint(
                              "${info.visibleFraction} of my widget is visible");
                          if(!mounted) return;
                          if (info.visibleFraction == 1) {
                            if (info.visibleFraction == 0) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          } else {
                            if (info.visibleFraction == 1) {
                              _controller.play();
                            } else {
                              _controller.pause();
                            }
                          }
                        },
                        child: VideoPlayer(_controller),
                      )));
            } else {
              return widget.backgroundUrl == null
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ))
                  : Container(
                      width: size.width,
                      height: size.height,
                      decoration: BoxDecoration(color: Colors.black),
                      child:
                          ImageHelper.loadImageNetWork(widget.backgroundUrl!));
            }
          },
        ),
        VideoProgressIndicator(
          _controller,
          allowScrubbing: true,
          colors: VideoProgressColors(playedColor: Colors.white),
        ),
      ],
    );
  }
}
