

import 'package:flutter/foundation.dart';
import 'package:insta_node_app/models/story.dart';
import 'package:insta_node_app/recources/repository.dart';
import 'package:insta_node_app/utils/image_picker.dart';

class StoryApi {
  final Repository _repository = Repository();
  Future<dynamic> createStory(List<Uint8List> media, String token) async {
    try {
      final mediaUrls = await Future.wait(media.map((e) => imageUpload(e, true)));
      final res = await _repository.postApi('story', {
        'media': mediaUrls,
      }, token);
      return Story.fromJson(res);
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> getStories(String token) async {
    try {
      final res = await _repository.getApi('story', token);
      return res.map((e) => Story.fromJson(e)).toList();
    } catch(err) {
      return err.toString();
    }
  }
}