import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoCardWidget extends StatefulWidget {
  final File? videoFile;
  final String? videoUrl;
  const VideoCardWidget({super.key, this.videoFile, this.videoUrl});

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
                    child: VideoPlayer(_controller)),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              );
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
