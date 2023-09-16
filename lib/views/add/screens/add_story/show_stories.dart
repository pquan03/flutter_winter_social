import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/story_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/views/add/screens/add_story/add_stories_modal.dart';
import 'package:insta_node_app/views/auth/screens/main_app.dart';
import 'package:insta_node_app/views/reel/widgets/video_card.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../../keep_alive_screen.dart';

class ShowStoriesScreen extends StatefulWidget {
  final List<AssetEntity> assets;
  const ShowStoriesScreen({super.key, required this.assets});

  @override
  State<ShowStoriesScreen> createState() => _ShowStoriesScreenState();
}

class _ShowStoriesScreenState extends State<ShowStoriesScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  bool _isLoading = false;

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void handleCreateStories() async {
    setState(() {
      _isLoading = true;
    });
    final newListStories = await Future.wait(widget.assets.map((e) async => {
      'file': await e.originFile,
      'duration': e.duration,
    }).toList());
    // convert to uint8list
    final listUint8List = await Future.wait(newListStories.map((e) async => {
      'file': await (e['file'] as dynamic).readAsBytes()!,
      'duration': e['duration'],
    }).toList());
    print(listUint8List);
    if(!mounted) return;
    final token = Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final res = await StoryApi().createStory(listUint8List, token);
    if(res is String) {
      if(!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
          if(!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => KeepAlivePage(child: MainAppScreen(initPage: 0,))), (route) => false);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PageView.builder(
                      onPageChanged: (page) {
                        setState(() {
                          _currentIndex = page;
                        });
                      },
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.assets.length,
                      itemBuilder: (context, index) {
                        final AssetEntity asset = widget.assets[index];
                        if (asset.type == AssetType.video) {
                          return SizedBox(
                            child: FutureBuilder(
                              future: asset.originFile,
                              builder: (context, snapShot) {
                                if (snapShot.connectionState ==
                                    ConnectionState.done) {
                                  return VideoCardWidget(
                                    isShowProgess: false,
                                    videoFile: snapShot.data,
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          );
                        } else {
                          return AssetEntityImage(
                            asset,
                            fit: BoxFit.cover,
                            isOriginal: false,
                            thumbnailSize: const ThumbnailSize.square(1000),
                          );
                        }
                      },
                    ),
                  )),
                  Positioned(
                      top: 10,
                      left: 20,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,),
                        ),
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: MediaQuery.sizeOf(context).height * 0.08,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(widget.assets.length > 1)
                  Expanded(
                      child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.assets.length,
                    itemBuilder: (context, index) {
                      AssetEntity assetEntity = widget.assets[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                          });
                          _pageController.jumpToPage(index);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: _currentIndex == index
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 3),
                              borderRadius: BorderRadius.circular(10)),
                          width: 45,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AssetEntityImage(
                              assetEntity,
                              isOriginal: false,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Text('Error'));
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheetCustom(
                          context,
                          AddStoriesModalWidget(
                            handleCreateStories: handleCreateStories,
                            isLoading: _isLoading,
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 50),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Next',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 15,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
