import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/recources/repository.dart';
import 'package:insta_node_app/utils/image_picker.dart';

class ReelApi {
  final Repository _repository = Repository();
  Future<dynamic> createReel(
      String caption, Uint8List backgrounImage , File videoFile, String token) async {
    try {
      final videoUrl = await imageUpload(videoFile, false);
      final backgroundUrl = await imageUpload(backgrounImage, true);
      final res = await _repository.postApi(
          'reels',
          {
            'content': caption,
            'videoUrl': videoUrl,
            'backgroundUrl': backgroundUrl,
          },
          token);
      return Reel.fromJson(res);
    } catch (err) {
      return err.toString();
    }
  }

  Future<dynamic> getReels(String token, int page, int limit) async {
    try {
      final res = await _repository.getApi('reels?page=$page&limit=$limit', token);
      return res.map((e) => Reel.fromJson(e)).toList();
    } catch (err) {
      return err.toString();
    }
  }

    Future<dynamic> likeReel(String reelId, String token) async {
    try {
      await _repository.patchApi('reel/$reelId/like', {}, token);
    } catch(err) {
      return err.toString();
    }
  }  

  Future<dynamic> unLikeReel(String reelId, String token) async {
    try {
      await _repository.patchApi('reel/$reelId/unlike', {}, token);
    } catch(err) {
      return err.toString();
    }
  }  


    Future<dynamic> saveReel(String reelId, String token) async {
    try  {
      await _repository.patchApi('save_reel/$reelId/save', {}, token);
    } catch(err) {
      return err.toString();
    }
  }

    Future<dynamic> unSaveReel(String reelId, String token) async {
    try  {
      await _repository.patchApi('save_reel/$reelId/unsave', {}, token);
    } catch(err) {
      return err.toString();
    }
  }

    Future<dynamic> getSavedReel(String token) async {
    try {
      final res = await _repository.getApi('saved_reels', token);
      return res.map((post)  {
        return Reel.fromJson(post);
      }).toList();
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> getUserReel(String userId, String token, int page, int limit) async {
    try {
      final res = await _repository.getApi('user_reel/$userId?page=$page&limit=$limit', token);
      return res.map((post)  {
        return Reel.fromJson(post);
      }).toList();
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> deleteReel(String reelId, String token) async {
    try {
      await _repository.delApi('reel/$reelId', token);
    } catch(err) {
      return err.toString();
    }
  }
}
