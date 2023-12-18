import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:insta_node_app/utils/helpers/asset_helper.dart';
import 'package:insta_node_app/utils/socket_config.dart';

class CallingScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const CallingScreen({super.key, required this.data});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    hanldePlaySound();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  void hanldePlaySound() {
    print('object');
    audioPlayer.play(AssetSource(AssetHelper.soundCall));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Stack(
        children: [
          Positioned(
            // center
            top: MediaQuery.of(context).size.height / 2 - 120,
            left: MediaQuery.of(context).size.width / 2 - 60,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(widget.data['avatar']),
                ),
                SizedBox(height: 20),
                Text(
                  widget.data['fullname'],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // button call
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    SocketConfig.endCall(widget.data);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: ShapeDecoration(
                        color: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                            side: BorderSide(color: Colors.white, width: 1))),
                    child: Icon(Icons.call_end, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // turn off sound
                    audioPlayer.stop();
                    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => VideoCallScreen()));
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: ShapeDecoration(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                            side: BorderSide(color: Colors.white, width: 1))),
                    child: Icon(Icons.call, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
