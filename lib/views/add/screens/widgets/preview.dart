import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/constants/dimension.dart';
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
    return Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              ),
            ),
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(Dimensions.dPaddingSmall),
                decoration: BoxDecoration(
                    gradient: Gradients.defaultGradientBackground),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Builder(builder: (_) {
                        if (widget.imagesBytes != null &&
                            widget.imagesBytes!.isNotEmpty) {
                          return CarouselSlider(
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height * 0.8,
                              initialPage: widget.initpage,
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                            ),
                            items: widget.imagesBytes!
                                .map((e) => ImageHelper.loadImageMemory(
                                      e,
                                      fit: BoxFit.cover,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ))
                                .toList(),
                          );
                        } else if (widget.imagesFile != null &&
                            widget.imagesFile!.isNotEmpty) {
                          return CarouselSlider(
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height * 0.8,
                              initialPage: widget.initpage,
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                            ),
                            items: widget.imagesFile!
                                .map((e) => ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: AssetEntityImage(
                                        e,
                                        fit: BoxFit.cover,
                                        isOriginal: false,
                                        thumbnailSize:
                                            const ThumbnailSize.square(1000),
                                      ),
                                    ))
                                .toList(),
                          );
                        }
                        return CarouselSlider(
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.8,
                            initialPage: widget.initpage,
                            enableInfiniteScroll: false,
                            viewportFraction: 1,
                          ),
                          items: widget.imagesString!
                              .map((e) => ImageHelper.loadImageNetWork(e,
                                  fit: BoxFit.cover,
                                  borderRadius: BorderRadius.circular(10)))
                              .toList(),
                        );
                      }),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
