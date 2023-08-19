import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:photo_manager/photo_manager.dart';

class PreviewScreen extends StatelessWidget {
  final List<AssetEntity>? imagesFile;
  final List<Uint8List>? imagesBytes;
  final List<String>? imagesString;
  const PreviewScreen(
      {super.key, this.imagesFile, this.imagesString, this.imagesBytes});

  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
      isClose: true,
      title: 'Preview',
      child: Container(
        alignment: Alignment.center,
        child: imagesFile != null
            ? CarouselSlider(
                options: CarouselOptions(
                    onPageChanged: (index, reason) {},
                    onScrolled: (_) async {},
                    enableInfiniteScroll: false,
                    height: MediaQuery.sizeOf(context).height * 0.65,
                    viewportFraction: 1),
                items: imagesFile!.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return AssetEntityImage(
                        i,
                        isOriginal: false,
                        thumbnailSize: ThumbnailSize.square(1000),
                      );
                    },
                  );
                }).toList(),
              )
            : imagesBytes != null
                ? CarouselSlider(
                    options: CarouselOptions(
                        onPageChanged: (index, reason) {},
                        onScrolled: (_) async {},
                        enableInfiniteScroll: false,
                        height: MediaQuery.sizeOf(context).height * 0.65,
                        viewportFraction: 1),
                    items: imagesBytes!.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.memory(
                            i,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      );
                    }).toList())
                : CarouselSlider(
                    options: CarouselOptions(
                        onPageChanged: (index, reason) {},
                        onScrolled: (_) async {},
                        enableInfiniteScroll: false,
                        height: MediaQuery.sizeOf(context).height * 0.65,
                        viewportFraction: 1),
                    items: imagesString!.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ImageHelper.loadImageNetWork(
                            i,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      );
                    }).toList(),
                  ),
      ),
    );
  }
}
