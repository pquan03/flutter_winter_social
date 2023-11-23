import 'package:flutter/material.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/story_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/views/auth/screens/main_app.dart';
import 'package:insta_node_app/views/keep_alive_screen.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class AddStoriesModalWidget extends StatefulWidget {
  final List<AssetEntity> assets;
  const AddStoriesModalWidget({super.key, required this.assets});

  @override
  State<AddStoriesModalWidget> createState() => _AddStoriesModalWidgetState();
}

class _AddStoriesModalWidgetState extends State<AddStoriesModalWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(user.avatar!),
            ),
            title: const Text(
              'Add to your story',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Radio(
              value: 1,
              groupValue: 1,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: Container(
              alignment: Alignment.center,
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(Icons.send),
            ),
            title: const Text('Message'),
            trailing: Radio(
              value: 2,
              groupValue: 1,
              onChanged: (value) {},
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: handleCreateStories,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightBlue),
              child: _isLoading
                  ? Center(child: const CircularProgressIndicator())
                  : Text(
                      'Share',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void handleCreateStories() async {
    setState(() {
      _isLoading = true;
    });
    final newListStories = await Future.wait(widget.assets
        .map((e) async => {
              'file': await e.originFile,
              'duration': e.duration,
            })
        .toList());
    // convert to uint8list
    final listUint8List = await Future.wait(newListStories
        .map((e) async => {
              'file': await (e['file'] as dynamic).readAsBytes()!,
              'duration': e['duration'],
            })
        .toList());
    if (!mounted) return;
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final res = await StoryApi().createStory(listUint8List, token);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => KeepAlivePage(
                      child: MainAppScreen(
                    initPage: 0,
                  ))),
          (route) => false);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
