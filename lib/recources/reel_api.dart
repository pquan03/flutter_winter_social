import 'dart:io';

import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/recources/repository.dart';
import 'package:insta_node_app/utils/image_picker.dart';

class ReelApi {
  final Repository _repository = Repository();
  Future<dynamic> createReel(
      String caption, File videoFile, String token) async {
    try {
      final videoUrl = await imageUpload(videoFile, false);
      final res = await _repository.postApi(
          'reels',
          {
            'content': caption,
            'videoUrl': videoUrl,
          },
          token);
      return Reel.fromJson(res);
    } catch (err) {
      return err.toString();
    }
  }

  Future<dynamic> getReels(String token) async {
    try {
      final res = await _repository.getApi('reels', token);
      return res.map((e) => Reel.fromJson(e)).toList();
    } catch (err) {
      return err.toString();
    }
  }
}
