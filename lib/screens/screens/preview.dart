import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';

class PreviewScreen extends StatelessWidget {
  final List<File> images;
  const PreviewScreen({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
      isClose: true,
      title: 'Preview',
      child: Container(
        alignment: Alignment.center,
        child: CarouselSlider(
          options: CarouselOptions(
              onPageChanged: (index, reason) {},
              onScrolled: (_) async {},
              enableInfiniteScroll: false,
              height: MediaQuery.sizeOf(context).height * 0.5,
              viewportFraction: 1),
          items: images.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return ImageHelper.loadImageFile(i,
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
