import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
// Instantiate the client
final AgoraClient client = AgoraClient(
  agoraConnectionData: AgoraConnectionData(
    appId: "ece4c37ecc29435cba0dff664140edcd",
    channelName: "winter",
    tempToken: '007eJxTYFi/0rpAd0VzxuZnhl3ysi/m226K5JuSwbd69pR1Kk9Omd9RYEhNTjVJNjZPTU42sjQxNk1OSjRISUszMzMxNDFITUlOufztRkpDICODwpnfTIwMEAjiszGUZ+aVpBYxMAAA51UiyA=='
  ),
  enabledPermission: [
    Permission.camera,
    Permission.microphone,
    Permission.storage,
  ]
);

// Initialize the Agora Engine
@override
void initState() {
  super.initState();
  initAgora();
}

@override
  void dispose() {
    super.dispose();
  }

void initAgora() async {
  await client.initialize();
}

// Build your layout
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client: client, layoutType: Layout.oneToOne,), 
            AgoraVideoButtons(client: client,),
          ],
        ),
      ),
    );
}
}
