// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';
// import 'package:insta_node_app/utils/socket_config.dart';

// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({Key? key}) : super(key: key);

//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
// // Instantiate the client
//   final AgoraClient client = AgoraClient(
//       agoraConnectionData: AgoraConnectionData(
//           appId: "d08cd92bd7154fd3afab7ab90b2815f7",
//           channelName: "winter",
//           tempToken:
//               '007eJxTYNiZrO53JGu/Z/LqOX+tD+xX3BNSun+DxKuKTGuxg5lZn8QVGFIMLJJTLI2SUswNTU3SUowT0xKTzBOTLA2SjCwMTdPMH+n/SmkIZGS4NNOJgREKQXw2hvLMvJLUIgYGAO0cIgA='),
//       enabledPermission: [
//         Permission.camera,
//         Permission.microphone,
//         Permission.storage,
//       ]);

// // Initialize the Agora Engine
//   @override
//   void initState() {
//     SocketConfig.socket.on('endCallToClient', (data) {
//       Navigator.pop(context);
//     });
//     super.initState();
//     initAgora();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void initAgora() async {
//     await client.initialize();
//   }

// // Build your layout
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AgoraVideoViewer(
//               client: client,
//               layoutType: Layout.grid,
//             ),
//             AgoraVideoButtons(
//               client: client,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
