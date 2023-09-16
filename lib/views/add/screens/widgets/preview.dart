import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:photo_manager/photo_manager.dart';

class PreviewScreen extends StatefulWidget {
  final List<AssetEntity>? imagesFile;
  final List<Uint8List>? imagesBytes;
  final List<String>? imagesString;
  final int initpage;
  const PreviewScreen(
      {super.key,
      this.imagesFile,
      this.imagesString,
      this.imagesBytes,
      this.initpage = 0});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: widget.imagesFile != null
              ? CarouselSlider(
                  disableGesture: true,
                  options: CarouselOptions(
                      onPageChanged: (index, reason) {},
                      onScrolled: (_) async {},
                      enableInfiniteScroll: false,
                      viewportFraction: 1),
                  items: widget.imagesFile!.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Hero(
                          tag: i,
                          child: AssetEntityImage(
                            i,
                            isOriginal: false,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            thumbnailSize: ThumbnailSize.square(1000),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              : widget.imagesBytes != null
                  ? CarouselSlider(
                      disableGesture: true,
                      options: CarouselOptions(
                          onPageChanged: (index, reason) {},
                          onScrolled: (_) async {},
                          enableInfiniteScroll: false,
                          viewportFraction: 1),
                      items: widget.imagesBytes!.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Hero(
                              tag: i,
                              child: GestureDetector(
                                onVerticalDragUpdate: (details) {
                                  if (details.delta.dy > 10) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: ImageHelper.loadImageMemory(
                                  i,
                                  width: double.infinity,
                                  height: 200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList())
                  : Column(
                      children: [
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(
                                    Icons.close,
                                    size: 30,
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: CarouselSlider(
                            disableGesture: true,
                            options: CarouselOptions(
                              initialPage: widget.initpage,
                              onPageChanged: (index, reason) {},
                              aspectRatio: 1,
                              viewportFraction: 1,
                              enableInfiniteScroll: false,
                              height: double.infinity,
                            ),
                            items: widget.imagesString!.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Hero(
                                    tag: i,
                                    child: GestureDetector(
                                      onVerticalDragUpdate: (details) {
                                        if (details.delta.dy > 10) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: ImageHelper.loadImageNetWork(i,
                                          fit: BoxFit.contain,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
