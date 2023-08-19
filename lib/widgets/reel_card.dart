import 'package:flutter/material.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/widgets/video_card.dart';
import 'package:video_player/video_player.dart';

class ReelCardWidget extends StatefulWidget {
  final Reel reel;
  final bool isMute;
  final Function handleMute;
  final int snappedPageIndex;
  final int currentIndex;
  const ReelCardWidget(
      {super.key,
      required this.reel,
      required this.isMute,
      required this.handleMute,
      required this.snappedPageIndex,
      required this.currentIndex});

  @override
  State<ReelCardWidget> createState() => _ReelCardWidgetState();
}

class _ReelCardWidgetState extends State<ReelCardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoCardWidget(
            videoUrl: widget.reel.videoUrl,
          ),
          buildTabSidebar(),
          buildInfo(widget.reel)
        ],
      ),
    );
  }

  Widget buildInfo(Reel reel) {
    return Positioned(
      left: 10,
      right: 70,
      bottom: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.reel.user!.avatar != null
                    ? NetworkImage(widget.reel.user!.avatar!)
                    : null,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                reel.user!.username!,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.white, width: 1)),
                child: Text(
                  'Follow',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // content
          Text(
            reel.content!,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            maxLines: 3,
          ),
          SizedBox(
            height: 10,
          ),
          // song name
          Text(
            'Song name: ${reel.user!.username!}',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget buildTabSidebar() {
    return Positioned(
        bottom: 20,
        right: 10,
        child: Column(
          children: [
            Column(
              children: const [
                Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 35,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '29.3k',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Column(
              children: const [
                Icon(
                  Icons.comment,
                  color: Colors.white,
                  size: 35,
                ),
                Text(
                  '163',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Column(
              children: const [
                Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 35,
                ),
                Text(
                  '26.4k',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 35,
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.white, width: 2)),
            ),
          ],
        ));
  }
}
