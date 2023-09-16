import 'package:flutter/material.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:insta_node_app/views/reel/widgets/video_card.dart';
import 'package:photo_manager/photo_manager.dart';

class ShowSelectImagePostWidget extends StatefulWidget {
  final AssetEntity? selectedAsset;
  const ShowSelectImagePostWidget({super.key, required this.selectedAsset});

  @override
  State<ShowSelectImagePostWidget> createState() => _ShowSelectImagePostWidgetState();
}

class _ShowSelectImagePostWidgetState extends State<ShowSelectImagePostWidget> {
    double aspectRatio = 1;
      final cropKey = GlobalKey<CropState>();
  @override
  Widget build(BuildContext context) {
    return widget.selectedAsset == null
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
                                future: widget.selectedAsset!.originFile,
                                builder: (context, snapShot) {
                                  if (snapShot.connectionState ==
                                      ConnectionState.done) {
                                    return
                                        // check type video and image
                                        widget.selectedAsset!.type == AssetType.video
                                            // auto play video
                                            ? VideoCardWidget(
                                                videoFile: snapShot.data!,
                                              )
                                            : Crop(
                                                alwaysShowGrid: true,
                                                aspectRatio: aspectRatio,
                                                key: cropKey,
                                                image: AssetEntityImageProvider(
                                                  widget.selectedAsset!,
                                                  isOriginal: false,
                                                  thumbnailSize:
                                                      const ThumbnailSize
                                                          .square(1000),
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
                      );
  }
}