import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';

class CropResultView extends StatelessWidget {
  const CropResultView({
    super.key,
    required this.selectedAssets,
    required this.croppedFiles,
    this.progress,
    this.heightFiles = 300.0,
    this.heightAssets = 120.0,
  });

  final List<AssetEntity> selectedAssets;
  final List<File> croppedFiles;
  final double? progress;
  final double heightFiles;
  final double heightAssets;

  Widget _buildTitle(String title, int length) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title, style: const TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Text(
              length.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCroppedImagesListView(BuildContext context, ScrollController? scrollController) {
    if (progress == null) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListView.builder(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            scrollDirection: Axis.horizontal,
            itemCount: croppedFiles.length,
            itemBuilder: (BuildContext _, int index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16.0,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Image.file(croppedFiles[index], fit: BoxFit.cover,
                    width: heightFiles * 0.8,
                    height: heightFiles * 0.8
                  ),
                ),
              );
            },
          ),
          if (progress! < 1.0)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(.5),
                ),
              ),
            ),
          if (progress! < 1.0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                    value: progress,
                    semanticsLabel: '${progress! * 100}%',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectedAssetsListView(Function handleJumpToPage) {
    if (selectedAssets.isEmpty) return const SizedBox.shrink();

    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: selectedAssets.length,
        itemBuilder: (BuildContext _, int index) {
          final AssetEntity asset = selectedAssets.elementAt(index);
          return GestureDetector(
            onTap: () => handleJumpToPage(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
              child: RepaintBoundary(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(image: AssetEntityImageProvider(asset)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    void handleJumpToPage(int page) {
      print(page);
      scrollController.animateTo(
        page * heightFiles,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedContainer(
          duration: kThemeChangeDuration,
          curve: Curves.easeInOut,
          height: croppedFiles.isNotEmpty ? heightFiles : 40.0,
          child: Column(
            children: <Widget>[
              _buildTitle('Cropped Images', croppedFiles.length),
              _buildCroppedImagesListView(context, scrollController),
            ],
          ),
        ),
        AnimatedContainer(
          duration: kThemeChangeDuration,
          curve: Curves.easeInOut,
          height: selectedAssets.isNotEmpty ? heightAssets : 40.0,
          child: Column(
            children: <Widget>[
              _buildTitle('Selected Assets', selectedAssets.length),
              _buildSelectedAssetsListView(handleJumpToPage),
            ],
          ),
        ),
      ],
    );
  }
}