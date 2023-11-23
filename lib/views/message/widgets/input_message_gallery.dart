import 'package:flutter/material.dart';
import 'package:insta_node_app/utils/media_services.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../constants/dimension.dart';

class InputMessageMedia extends StatefulWidget {
  final int maxCount;
  final RequestType requestType;
  final Function(List<AssetEntity>) onSend;
  const InputMessageMedia(
      {super.key,
      required this.maxCount,
      required this.requestType,
      required this.onSend});

  @override
  State<InputMessageMedia> createState() => _InputMessageMediaState();
}

class _InputMessageMediaState extends State<InputMessageMedia> {
  final ScrollController _scrollController = ScrollController();
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  double aspectRatio = 1;
  int _currentPage = 1;

  @override
  void initState() {
    MediaServices().loadAlbums(widget.requestType, _currentPage).then((value) {
      setState(() {
        albumList = value;
        selectedAlbum = value[0];
      });
      MediaServices().loadAssets(selectedAlbum!, _currentPage).then((value) {
        setState(() {
          assetList = value;
        });
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _currentPage++;
        MediaServices().loadAssets(selectedAlbum!, _currentPage).then((value) {
          setState(() {
            assetList = [...assetList, ...value];
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              Container(
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.dPaddingSmall),
                child: DropdownButton<AssetPathEntity>(
                  value: selectedAlbum,
                  onChanged: (AssetPathEntity? value) async {
                    setState(() {
                      selectedAlbum = value;
                    });
                    MediaServices()
                        .loadAssets(selectedAlbum!, _currentPage)
                        .then((value) {
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
              ),
              assetList.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
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
                        int idx = selectedAssetList
                            .indexWhere((element) => element == assetEntity);
                        return GestureDetector(
                          onTap: () {
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
                              Positioned.fill(child: assetWidget(assetEntity)),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 32,
                                  width: 32,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: idx == -1
                                        ? Colors.transparent
                                        : Colors.lightBlue,
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
                              )
                            ],
                          ),
                        );
                      }),
            ],
          ),
          selectedAssetList.isEmpty
              ? Container()
              : Positioned(
                  bottom: 20,
                  right: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: () => widget.onSend(selectedAssetList),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Send ${selectedAssetList.length}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget assetWidget(AssetEntity assetEntity) {
    return AssetEntityImage(
      assetEntity,
      isOriginal: false,
      thumbnailSize: const ThumbnailSize.square(1000),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Text('Error'));
      },
    );
  }
}
