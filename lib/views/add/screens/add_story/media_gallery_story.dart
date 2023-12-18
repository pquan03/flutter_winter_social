import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';
import 'package:insta_node_app/constants/size.dart';
import 'package:insta_node_app/utils/animate_route.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:insta_node_app/views/add/screens/add_post/add_post_caption.dart';
import 'package:insta_node_app/utils/media_services.dart';
import 'package:insta_node_app/views/add/screens/add_story/show_stories.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class MediaGalleryStoryScreen extends StatefulWidget {
  final Function? handleNaviTapped;
  const MediaGalleryStoryScreen({super.key, this.handleNaviTapped});

  @override
  State<MediaGalleryStoryScreen> createState() =>
      _MediaGalleryStoryScreenState();
}

class _MediaGalleryStoryScreenState extends State<MediaGalleryStoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final cropKey = GlobalKey<CropState>();
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  bool _isSelectOne = true;
  double aspectRatio = 1;
  int _currentPage = 1;
  bool isLoading = true;

  @override
  void initState() {
    MediaServices().loadAlbums(RequestType.all, 1).then((value) {
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
      // widget.handleHideAddPostButton!();
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
                alignment: Alignment.center,
                child: Text(
                  'Add to story',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: TSizes.appBarHeight,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  onTap: () {
                    setState(() {
                      selectedAssetList.clear();
                      _isSelectOne = !_isSelectOne;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: !_isSelectOne
                        ? Text('Cancel',
                            style: Theme.of(context).textTheme.bodyLarge)
                        : Text(
                            'Select',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? LoadingShimmer(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 10,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          : Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: [
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 2,
                        child: InkWell(
                          onTap: () {
                            handleCapturePhoto();
                          },
                          child: Stack(
                            children: [
                              Container(
                                color: Colors.grey[900],
                                child: GestureDetector(
                                  onTap: handleCapturePhoto,
                                  child: const Center(
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 5,
                                child: Text(
                                  'Camera',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      ...[...assetList].asMap().entries.map((e) {
                        AssetEntity assetEntity = assetList[e.key];
                        return StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 2,
                          child: assetWidget(assetEntity, e.key),
                        );
                      }).toList()
                    ],
                  ),
                ),
                if (selectedAssetList.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      height: MediaQuery.sizeOf(context).height * 0.1,
                      color: Colors.black87,
                      child: Row(
                        children: [
                          Expanded(
                              child: ListView.builder(
                            controller: _scrollController2,
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedAssetList.length,
                            itemBuilder: (context, index) {
                              AssetEntity assetEntity =
                                  selectedAssetList[index];
                              return Container(
                                margin: const EdgeInsets.only(right: 16),
                                width: 50,
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
                              );
                            },
                          )),
                          ElevatedButton(
                            onPressed: () {
                              // handleChooseMedia();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ShowStoriesScreen(
                                      assets: selectedAssetList)));
                            },
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(100, 50),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            child: const Text(
                              'Next >',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
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

  Widget assetWidget(AssetEntity assetEntity, int index) {
    if (_isSelectOne) {
      return InkWell(
          onTap: () async {
            if (assetEntity.type == AssetType.video) {
              if (assetEntity.videoDuration.inSeconds > 30) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Warning!'),
                          content: const Text(
                              'You can only select video less than 30 seconds'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Ok',
                                  style: TextStyle(color: Colors.blue),
                                )),
                          ],
                        ));
                return;
              } else {
                if (!mounted) return;
                Navigator.of(context).push(
                    createRoute(ShowStoriesScreen(assets: [assetEntity])));
              }
            } else {
              final newImageFile =
                  await THelperFunctions.convertAssetEntityToUint8List(
                      assetEntity);
              if (!mounted) return;
              var imageEditor = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditor(
                    image: newImageFile,
                    // allowMultiple: true,
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
                    builder: (_) => ShowStoriesScreen(assets: [assetEntity])));
              }
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: AssetEntityImage(
                  assetEntity,
                  isOriginal: false,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low,
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
          ));
    } else {
      int idx =
          selectedAssetList.indexWhere((element) => element == assetEntity);
      return GestureDetector(
        onTap: () {
          // widget.handleHideAddPostButton!();
          //  scroll to bottom
          if (selectedAssetList.length > 3) {
            _scrollController2.animateTo(
              _scrollController2.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          }
          if (selectedAssetList.length > 4) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Warning!'),
                      content: const Text('You can only select 5 items'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Ok',
                              style: TextStyle(color: Colors.blue),
                            )),
                      ],
                    ));
            return;
          }
          //  get duration of video
          if (assetEntity.type == AssetType.video) {
            if (assetEntity.videoDuration.inSeconds > 30) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Warning!'),
                        content: const Text(
                            'You can only select video less than 30 seconds'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Ok',
                                style: TextStyle(color: Colors.blue),
                              )),
                        ],
                      ));
              return;
            }
          }
          setState(() {
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
                child: AssetEntityImage(
              assetEntity,
              isOriginal: false,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Error'));
              },
            )),
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                alignment: Alignment.center,
                height: 32,
                width: 32,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: idx == -1 ? Colors.transparent : Colors.lightBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: idx == -1
                    ? Container()
                    : Text(
                        (idx + 1).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
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
        ),
      );
    }
  }
}

String convertDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}
