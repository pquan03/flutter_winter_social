import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';

class PreviewScreen extends StatelessWidget {
  final List<File>? imagesFile;
  final List<String>? imagesString;
  const PreviewScreen({super.key, this.imagesFile, this.imagesString});

  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
      isClose: true,
      title: 'Preview',
      child: Container(
        alignment: Alignment.center,
        child: imagesFile != null ?  CarouselSlider(
          options: CarouselOptions(
              onPageChanged: (index, reason) {},
              onScrolled: (_) async {},
              enableInfiniteScroll: false,
              height: MediaQuery.sizeOf(context).height * 0.5,
              viewportFraction: 1),
          items:  imagesFile!.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return ImageHelper.loadImageFile(i,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    );
              },
            );
          }).toList(),
        ) : CarouselSlider(
          options: CarouselOptions(
              onPageChanged: (index, reason) {},
              onScrolled: (_) async {},
              enableInfiniteScroll: false,
              height: MediaQuery.sizeOf(context).height * 0.5,
              viewportFraction: 1),
          items:  imagesString!.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return ImageHelper.loadImageNetWork(i,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
