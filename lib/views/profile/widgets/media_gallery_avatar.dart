import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/utils.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:insta_node_app/utils/media_services.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaImageScreen extends StatefulWidget {
  final int maxCount;
  final RequestType requestType;
  final bool isChangeAvatar;
  const MediaImageScreen(
      {super.key,
      required this.maxCount,
      required this.requestType,
      required this.isChangeAvatar});

  @override
  State<MediaImageScreen> createState() => _MediaImageScreenState();
}

class _MediaImageScreenState extends State<MediaImageScreen> {
  final cropKey = GlobalKey<CropState>();
  final ScrollController _scrollController = ScrollController();
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
    MediaServices().loadAlbums(widget.requestType, 1).then((value) {
      setState(() {
        albumList = value;
        selectedAlbum = value[0];
      });
      MediaServices().loadAssets(selectedAlbum!, 1).then((value) {
        setState(() {
          assetList = value;
        });
        if (value.isNotEmpty) {
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
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
              widget.isChangeAvatar
                  ? DropdownButton<AssetPathEntity>(
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
                    )
                  : Text(
                      'New Post',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
              Spacer(),
              GestureDetector(
                  onTap: () async {
                    final imageFile = await selectedAsset!.originFile;
                    // convert file to unit8list
                    final newImageFile =
                        Uint8List.fromList(imageFile!.readAsBytesSync());
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
                      Navigator.pop(context, imageEditor);
                    }
                  },
                  child: Icon(
                    Icons.arrow_right_alt,
                    size: 30,
                    color: Colors.lightBlue,
                  ))
            ],
          ),
        ),
        body: ListView(
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
                                return Crop(
                                  alwaysShowGrid: true,
                                  aspectRatio: aspectRatio,
                                  key: cropKey,
                                  image: AssetEntityImageProvider(
                                    selectedAsset!,
                                    isOriginal: false,
                                    thumbnailSize:
                                        const ThumbnailSize.square(1000),
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
                                    shape: BoxShape.circle, color: Colors.grey),
                                child: const Icon(Icons.crop)),
                          ),
                        )
                      ],
                    ),
                  ),
            if (widget.isChangeAvatar == false)
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
                              Text(album.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(
                                width: 8,
                              ),
                              FutureBuilder(
                                future: album.assetCountAsync,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),);
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
                      if (_isSelectOne) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAsset = assetEntity;
                            });
                          },
                          child: Opacity(
                              opacity: selectedAsset == assetEntity ? .5 : 1,
                              child: assetWidget(assetEntity)),
                        );
                      } else {
                        int index = selectedAssetList
                            .indexWhere((element) => element == assetEntity);
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
                                      opacity:
                                          selectedAsset == assetEntity ? .5 : 1,
                                      child: assetWidget(assetEntity))),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 32,
                                  width: 32,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: index == -1
                                        ? Colors.transparent
                                        : Colors.lightBlue,
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
                    },
                  ),
          ],
        ));
  }

  Widget assetWidget(AssetEntity assetEntity) {
    return AssetEntityImage(
      assetEntity,
      isOriginal: false,
      thumbnailSize: const ThumbnailSize.square(1000),
      fit: BoxFit.cover,
      errorBuilder: (context, error, StackTrace) {
        return const Center(child: Text('Error'));
      },
    );
  }
}
