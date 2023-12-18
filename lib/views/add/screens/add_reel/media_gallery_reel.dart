import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';
import 'package:insta_node_app/constants/dimension.dart';
import 'package:insta_node_app/views/add/screens/widgets/preview_video_edit.dart';
import 'package:insta_node_app/utils/animate_route.dart';
import 'package:insta_node_app/utils/media_services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class MediaGalleryReelScreen extends StatefulWidget {
  final Function? handleNaviTapped;
  const MediaGalleryReelScreen({super.key, this.handleNaviTapped});
  @override
  State<MediaGalleryReelScreen> createState() => _MediaGalleryReelScreenState();
}

class _MediaGalleryReelScreenState extends State<MediaGalleryReelScreen> {
  final ScrollController _scrollController = ScrollController();
  final cropKey = GlobalKey<CropState>();
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  int _currentPage = 1;
  bool isLoading = true;

  @override
  void initState() {
    MediaServices().loadAlbums(RequestType.video, 1).then((value) {
      if (value.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      setState(() {
        albumList = value;
        selectedAlbum = value[0];
      });
      MediaServices().loadAssets(selectedAlbum!, 1).then((value) {
        setState(() {
          assetList = value;
          isLoading = false;
        });
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        MediaServices()
            .loadAssets(selectedAlbum!, _currentPage + 1)
            .then((value) {
          setState(() {
            _currentPage++;
            assetList = [...assetList, ...value];
          });
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        title: Row(
          children: [
            GestureDetector(
                onTap: () {
                  if (widget.handleNaviTapped != null) {
                    widget.handleNaviTapped!();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Icon(
                  Icons.close,
                  size: 30,
                )),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'New reel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.dPaddingSmall),
            child: Row(
              children: [
                DropdownButton<AssetPathEntity>(
                  value: selectedAlbum,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  onChanged: (AssetPathEntity? value) async {
                    setState(() {
                      selectedAlbum = value;
                    });
                    MediaServices().loadAssets(selectedAlbum!, 1).then((value) {
                      setState(() {
                        assetList = value;
                      });
                    });
                  },
                  items: albumList.map<DropdownMenuItem<AssetPathEntity>>(
                      (AssetPathEntity album) {
                    return DropdownMenuItem<AssetPathEntity>(
                      value: album,
                      child: Row(
                        children: [
                          Text(
                            album.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          FutureBuilder(
                            future: album.assetCountAsync,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data.toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const Spacer(),
                InkWell(
                  onTap: handleRecordVideo,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              isLoading
                  ? LoadingShimmer(
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: 10,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  : assetList.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          itemCount: assetList.length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemBuilder: (context, index) {
                            AssetEntity assetEntity = assetList[index];
                            return assetWidget(assetEntity, index);
                          },
                        )
                      : Center(child: Text('No video found')),
            ],
          ),
        ],
      ),
    );
  }

  void handleRecordVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? cameraVideo =
        await picker.pickVideo(source: ImageSource.camera);
    if (cameraVideo == null) return;
    // convert xfile to file
    final convertToFile = File(cameraVideo.path);
    if (!mounted) return;
    Navigator.of(context)
        .push(createRoute(PreviewEditVideoScreen(videoFile: convertToFile)));
  }

  Widget assetWidget(AssetEntity assetEntity, int index) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () async {
              final convertToFile = await assetEntity.originFile;
              if (!mounted) return;
              Navigator.of(context).push(createRoute(
                  PreviewEditVideoScreen(videoFile: convertToFile!)));
            },
            child: AssetEntityImage(
              assetEntity,
              isOriginal: false,
              thumbnailSize: const ThumbnailSize.square(1000),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Error'));
              },
            ),
          ),
        ),
        if (assetEntity.type == AssetType.video)
          Positioned(
            bottom: 5,
            right: 5,
            child: Text(
              // convert to 00:00
              convertDuration(assetEntity.videoDuration),
              style: const TextStyle(color: Colors.white),
            ),
          )
      ],
    );
  }

  // convert duration to 00:00
  String convertDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
