import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_editor_plus/data/image_item.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';
import 'package:insta_node_app/utils/convert_assest_entity_to_uint8list.dart';
import 'package:insta_node_app/views/add/screens/add_post/add_post_caption.dart';
import 'package:insta_node_app/utils/media_services.dart';
import 'package:insta_node_app/views/add/screens/add_story/media_gallery_story.dart';
import 'package:insta_node_app/views/add/screens/widgets/show_select_image_post.dart';
import 'package:insta_node_app/views/add/screens/widgets/sliver_appbar_delegate.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaGalleryPostScreen extends StatefulWidget {
  final Function? handleNaviTapped;
  const MediaGalleryPostScreen({super.key, this.handleNaviTapped});

  @override
  State<MediaGalleryPostScreen> createState() => _MediaGalleryPostScreenState();
}

class _MediaGalleryPostScreenState extends State<MediaGalleryPostScreen> {
  final ScrollController _scrollController = ScrollController();
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  AssetEntity? selectedAsset;
  bool _isSelectOne = true;
  int _currentPage = 1;

  @override
  void initState() {
    MediaServices().loadAlbums(RequestType.image, 1).then((value) {
      setState(() {
        albumList = [...value];
        selectedAlbum = value[0];
      });
      MediaServices().loadAssets(selectedAlbum!, 1).then((value) {
        setState(() {
          assetList = value;
        });
        if (value.isNotEmpty) {
          if (!mounted) return;
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
                    'New post',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
              GestureDetector(
                onTap: handleChooseMedia,
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: ShowSelectImagePostWidget(selectedAsset: selectedAsset),
              ),
              SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: SliverAppBarDelegate(
                    AppBar(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      automaticallyImplyLeading: false,
                      primary: false,
                      centerTitle: false,
                      title: Row(
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
                            items: albumList
                                .map<DropdownMenuItem<AssetPathEntity>>(
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
                                          return const Text('haghaha');
                                        }
                                      },
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              if (_isSelectOne) {
                                setState(() {
                                  _isSelectOne = !_isSelectOne;
                                  selectedAssetList.add(selectedAsset!);
                                });
                              } else {
                                setState(() {
                                  _isSelectOne = !_isSelectOne;
                                  selectedAssetList.clear();
                                });
                              }
                            },
                            icon: Icon(
                              Icons.select_all_rounded,
                              size: 30,
                            )),
                        IconButton(
                            onPressed: handleCapturePhoto,
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              size: 30,
                            )),
                      ],
                    ),
                  ))
            ];
          },
          body: assetList.isEmpty
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
              : GridView.builder(
                  shrinkWrap: true,
                  itemCount: assetList.length,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (context, index) {
                    AssetEntity assetEntity = assetList[index];
                    return assetWidget(assetEntity);
                  },
                ),
        ));
  }

  Widget assetWidget(AssetEntity assetEntity) {
    if (_isSelectOne) {
      return GestureDetector(
          onTap: () {
            if (selectedAsset == assetEntity) return;
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
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text('Error'));
                      },
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
              )));
    } else {
      final index = selectedAssetList.indexOf(assetEntity);
      return GestureDetector(
        onTap: () {
          if (index == -1) {
            setState(() {
              selectedAssetList.add(assetEntity);
              selectedAsset = assetEntity;
            });
          } else {
            if (selectedAsset == assetEntity) {
              setState(() {
                selectedAssetList.remove(assetEntity);
                if (selectedAssetList.isEmpty) {
                  return;
                } else {
                  selectedAsset = selectedAssetList.last;
                }
              });
            } else {
              setState(() {
                selectedAsset = assetEntity;
              });
            }
          }
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
                      errorBuilder: (context, error, stackTrace) {
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

  void handleChooseMedia() async {
    if (_isSelectOne) {
      final newImageFile = await convertAssetEntityToUint8List(selectedAsset!);
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
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AddPostCaptionScreen(
                  imageList: [imageEditor],
                )));
      }
    } else {
      if (selectedAssetList.isEmpty || selectedAssetList.length == 1) {
        final newImageFile =
            await convertAssetEntityToUint8List(selectedAsset!);
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddPostCaptionScreen(
                    imageList: [imageEditor],
                  )));
        }
        return;
      }
      final newImageFiles = await Future.wait(
          selectedAssetList.map((e) => convertAssetEntityToUint8List(e)));
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
        final newListImage = (imageEditor as List<ImageItem>)
            .map((e) => Uint8List.fromList(e.image))
            .toList();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AddPostCaptionScreen(
                  imageList: newListImage,
                )));
      }
    }
  }

  void handleCapturePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;
    final imageFile = await photo.readAsBytes();
    if (!mounted) return;
    var imageEditor = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: imageFile,
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
        ));
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AddPostCaptionScreen(
              imageList: [imageEditor],
            )));
  }
}
