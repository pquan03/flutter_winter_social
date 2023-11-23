import 'package:flutter/material.dart';
import 'package:insta_node_app/models/conversation.dart';

import '../../../constants/dimension.dart';

class CallMessageWidget extends StatelessWidget {
  final Call call;
  final String createAt;
  const CallMessageWidget(
      {super.key, required this.call, required this.createAt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.sizeOf(context).width * 0.7,
      margin: const EdgeInsets.only(bottom: Dimensions.dPaddingSmall),
      decoration: ShapeDecoration(
          color: Colors.grey.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          )),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: ShapeDecoration(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  child: Icon(
                    Icons.video_call,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    call.video == true ? 'Video chat' : 'Audio Call',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${call.times.toString()} secs',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: Text(
              'Call back',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCallItem() {
    String formatTime(int seconds) {
      int hours = seconds ~/ 3600;
      int minutes = (seconds % 3600) ~/ 60;
      int remainingSeconds = seconds % 60;

      String result = '';

      if (hours > 0) {
        result += '${hours.toString().padLeft(2, '0')}:';
      }

      result += '${minutes.toString().padLeft(2, '0')}:';
      result += remainingSeconds.toString().padLeft(2, '0');

      return result;
    }

    final missCall = call.times == 0 ? true : false;
    final missVideoCall = call.times == 0 && call.video == true ? true : false;
    Icon icon = missCall
        ? missVideoCall
            ? Icon(Icons.videocam_off)
            : Icon(Icons.call)
        : call.video == true
            ? Icon(Icons.video_call)
            : Icon(Icons.call_missed);
    String text = missCall
        ? missVideoCall
            ? 'Missed Video Call'
            : 'Missed Call'
        : call.video == true
            ? 'Video chat'
            : 'Audio Call';
    String time = call.times == 0 ? 'Today' : formatTime(call.times!);
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            child: Icon(
              icon.icon,
              color: Colors.white,
            )),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            Text(
              time,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
