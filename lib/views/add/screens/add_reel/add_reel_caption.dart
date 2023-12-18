import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:insta_node_app/constants/dimension.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/reel_api.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:insta_node_app/views/keep_alive_screen.dart';
import 'package:insta_node_app/views/navigation_view.dart';
import 'package:provider/provider.dart';

class AddReelCaptionScreen extends StatefulWidget {
  final File reelFile;
  final Uint8List backgroundImage;
  const AddReelCaptionScreen(
      {super.key, required this.reelFile, required this.backgroundImage});

  @override
  State<AddReelCaptionScreen> createState() => _AddReelCaptionScreenState();
}

class _AddReelCaptionScreenState extends State<AddReelCaptionScreen> {
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void handleCreateReel() async {
    setState(() {
      _isLoading = true;
    });
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final res = await ReelApi().createReel(_captionController.text,
        widget.backgroundImage, widget.reelFile, token);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      // navigation to reel screen
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => KeepAlivePage(
                      child: MainAppScreen(
                    initPage: 3,
                  ))),
          (route) => false);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: const [
                Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'New reel',
                ),
              ],
            )),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Container(
                height: 400,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      widget.backgroundImage,
                      fit: BoxFit.cover,
                    ))),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.dPaddingMedium),
            child: TextField(
              controller: _captionController,
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              maxLines: 3,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.2,
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.1,
            child: Container(
              padding: const EdgeInsets.all(Dimensions.dPaddingSmall),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Back',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: handleCreateReel,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Share',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
