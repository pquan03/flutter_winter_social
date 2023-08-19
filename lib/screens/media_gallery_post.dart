import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_editor_plus/data/image_item.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/utils.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:insta_node_app/utils/media_services.dart';
import 'package:insta_node_app/widgets/video_card.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaGalleryPostScreen extends StatefulWidget {
  final Function navigationTapped;
  final List<Uint8List> imageList;
  final Function(List<Uint8List>) handleChangeImageList;
  const MediaGalleryPostScreen(
      {Key? key,
      required this.navigationTapped,
      required this.imageList,
      required this.handleChangeImageList,
      })
      : super(key: key);
  @override
  State<MediaGalleryPostScreen> createState() => _MediaGalleryPostScreenState();
}

class _MediaGalleryPostScreenState extends State<MediaGalleryPostScreen> {
  final ScrollController _scrollController = ScrollController();
  final cropKey = GlobalKey<CropState>();
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  AssetEntity? selectedAsset;
  bool _isSelectOne = true;
  double aspectRatio = 1;
  int _currentPage = 1;

  @override
  void initState() {
    MediaServices().loadAlbums(RequestType.image, 1).then((value) {
      setState(() {
        albumList = value;
        selectedAlbum = value[0];
      });
      MediaServices().loadAssets(selectedAlbum!, 1).then((value) {
        setState(() {
          assetList = value;
        });
        if (value.isNotEmpty) {
          if(!mounted) return;
          setState(() {
            selectedAsset = value[0];
          });
        }
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

  void handleChooseMedia() async {
    if (_isSelectOne) {
      final imageFile = await selectedAsset!.originFile;
      final newImageFile = Uint8List.fromList(imageFile!.readAsBytesSync());
      if (!mounted) return;
      var imageEditor = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: newImageFile,
            features: const ImageEditorFeatures(
              pickFromGallery: false,
              captureFromCamera: false,
              crop: true,
              blur: true,
              brush: true,
              emoji: true,
              filters: true,
              flip: true,
              rotate: true,
              text: true,
            ),
          ),
        ),
      );
      if (imageEditor != null) {
        if (!mounted) return;
        widget.handleChangeImageList([imageEditor as Uint8List]);
      }
    } else {
      if (selectedAssetList.isEmpty) {
        final imageFile = await selectedAsset!.originFile;
        final newImageFile = Uint8List.fromList(imageFile!.readAsBytesSync());
        if (!mounted) return;
        var imageEditor = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageEditor(
              image: newImageFile,
              features: const ImageEditorFeatures(
                pickFromGallery: false,
                captureFromCamera: false,
                crop: true,
                blur: true,
                brush: true,
                emoji: true,
                filters: true,
                flip: true,
                rotate: true,
                text: true,
              ),
            ),
          ),
        );
        if (imageEditor != null) {
          if (!mounted) return;
          print('ahihi');
          widget.handleChangeImageList([imageEditor as Uint8List]);
          widget.navigationTapped();
        }
        return;
      }
      final imageFiles = await Future.wait(
          selectedAssetList.map((e) async => await e.originFile));
      final newImageFiles = imageFiles
          .map((e) => Uint8List.fromList(e!.readAsBytesSync()))
          .toList();
      if (!mounted) return;
      var imageEditor = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            images: newImageFiles,
            allowMultiple: true,
            features: const ImageEditorFeatures(
              pickFromGallery: false,
              captureFromCamera: false,
              crop: true,
              blur: true,
              brush: true,
              emoji: true,
              filters: true,
              flip: true,
              rotate: true,
              text: true,
            ),
          ),
        ),
      );
      if (imageEditor != null) {
        if (!mounted) return;
        // convert List<ImageItem> to List<Uint8List>
        final newListImage = (imageEditor as List<ImageItem>)
            .map((e) => Uint8List.fromList(e.image))
            .toList();
        widget.handleChangeImageList(newListImage);
      }
    }
    widget.navigationTapped();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
                onTap: () => Navigator.pop(context),
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
                  'New Post',
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            GestureDetector(
              onTap: handleChooseMedia,
              child: Icon(
                Icons.arrow_right_alt,
                color: Colors.lightBlue,
                size: 30,
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              selectedAsset == null
                  ? Container(
                      height: 400,
                      width: double.infinity,
                      color: Colors.grey,
                    )
                  : SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: FutureBuilder(
                              future: selectedAsset!.originFile,
                              builder: (context, snapShot) {
                                if (snapShot.connectionState ==
                                    ConnectionState.done) {
                                  return
                                      // check type video and image
                                      selectedAsset!.type == AssetType.video
                                      // auto play video
                                          ? 
                                          VideoCardWidget(videoFile: snapShot.data!,)
                                          : Crop(
                                              alwaysShowGrid: true,
                                              aspectRatio: aspectRatio,
                                              key: cropKey,
                                              image: AssetEntityImageProvider(
                                                selectedAsset!,
                                                isOriginal: false,
                                                thumbnailSize:
                                                    const ThumbnailSize.square(
                                                        1000),
                                              ),
                                            );
                                } else {
                                  return Container(
                                    color: Colors.grey,
                                  );
                                }
                              },
                            ),
                          ),
                          Positioned(
                            left: 10,
                            bottom: 10,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  aspectRatio = aspectRatio == 1 ? 4 / 5 : 1;
                                });
                              },
                              child: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey),
                                  child: const Icon(Icons.crop)),
                            ),
                          )
                        ],
                      ),
                    ),
              Container(
                height: 50,
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    DropdownButton<AssetPathEntity>(
                      value: selectedAlbum,
                      onChanged: (AssetPathEntity? value) async {
                        setState(() {
                          selectedAlbum = value;
                        });
                        MediaServices()
                            .loadAssets(selectedAlbum!, 1)
                            .then((value) {
                          setState(() {
                            assetList = value;
                          });
                          if (value.isNotEmpty) {
                            setState(() {
                              selectedAsset = value[0];
                            });
                          }
                        });
                      },
                      items: albumList.map<DropdownMenuItem<AssetPathEntity>>(
                          (AssetPathEntity album) {
                        return DropdownMenuItem<AssetPathEntity>(
                          value: album,
                          child: Row(
                            children: [
                              Text(album.name),
                              const SizedBox(
                                width: 8,
                              ),
                              FutureBuilder(
                                future: album.assetCountAsync,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data.toString());
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
                    GestureDetector(
                      onTap: () {
                        if (_isSelectOne) {
                          setState(() {
                            selectedAssetList.add(selectedAsset!);
                          });
                        }
                        setState(() {
                          _isSelectOne = !_isSelectOne;
                          selectedAssetList.clear();
                          selectedAssetList.add(selectedAsset!);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: ShapeDecoration(
                            color: _isSelectOne
                                ? Colors.black38
                                : Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: const Icon(Icons.select_all_outlined),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: ShapeDecoration(
                          color: Colors.black38,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: const Icon(Icons.camera_alt_outlined),
                    ),
                  ],
                ),
              ),
              assetList.isEmpty
                  ? GridView.builder(
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
                    )
                  : GridView.builder(
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
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget assetWidget(AssetEntity assetEntity, int index) {
    if (_isSelectOne) {
      return GestureDetector(
          onTap: () {
            setState(() {
              selectedAsset = assetEntity;
            });
          },
          child: Opacity(
              opacity: selectedAsset == assetEntity ? .5 : 1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AssetEntityImage(
                      assetEntity,
                      isOriginal: false,
                      thumbnailSize: const ThumbnailSize.square(1000),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (context, error, StackTrace) {
                        return const Center(child: Text('Error'));
                      },
                    ),
                  ),
                  if(assetEntity.type == AssetType.video)
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Text(
                      // convert to 00:00
                      convertDuration(assetEntity.videoDuration),
                      style: const TextStyle(color: Colors.white),),
                  )
                ],
              )));
    } else {
      int index =
          selectedAssetList.indexWhere((element) => element == assetEntity);
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedAsset = assetEntity;
            if (selectedAssetList.contains(assetEntity)) {
              selectedAssetList.remove(assetEntity);
            } else {
              selectedAssetList.add(assetEntity);
            }
          });
        },
        child: Stack(
          children: [
            Positioned.fill(
                child: Opacity(
                    opacity: selectedAsset == assetEntity ? .5 : 1,
                    child: AssetEntityImage(
                      assetEntity,
                      isOriginal: false,
                      thumbnailSize: const ThumbnailSize.square(1000),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, StackTrace) {
                        return const Center(child: Text('Error'));
                      },
                    ))),
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                alignment: Alignment.center,
                height: 32,
                width: 32,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: index == -1 ? Colors.transparent : Colors.lightBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: index == -1
                    ? Container()
                    : Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            )
          ],
        ),
      );
    }
  }

  // convert duration to 00:00
  String convertDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
