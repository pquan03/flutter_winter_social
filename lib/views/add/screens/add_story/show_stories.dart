import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/constants/size.dart';
import 'package:insta_node_app/views/add/screens/add_story/add_stories_modal.dart';
import 'package:insta_node_app/views/reel/widgets/video_card.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class ShowStoriesScreen extends StatefulWidget {
  final List<AssetEntity> assets;
  const ShowStoriesScreen({super.key, required this.assets});

  @override
  State<ShowStoriesScreen> createState() => _ShowStoriesScreenState();
}

class _ShowStoriesScreenState extends State<ShowStoriesScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

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
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: TSizes.defaultSpace),
              height: MediaQuery.sizeOf(context).height * 0.08,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.assets.length > 1)
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
                            assets: widget.assets,
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
