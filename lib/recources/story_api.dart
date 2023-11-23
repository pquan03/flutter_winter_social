import 'package:insta_node_app/models/story.dart';
import 'package:insta_node_app/recources/repository.dart';
import 'package:insta_node_app/utils/image_picker.dart';

class StoryApi {
  final Repository _repository = Repository();
  Future<dynamic> createStory(
      List<Map<String, dynamic>> data, String token) async {
    try {
      final mediaUrls = await Future.wait(data.map((e) async => {
            'media': await imageUpload(e['file'], true),
            'duration': e['duration'],
          }));
      for (var i = 0; i < data.length; i++) {
        try {
          await _repository.postApi(
              'story',
              {
                'media': mediaUrls[i]['media'],
                'duration': mediaUrls[i]['duration'] == 0
                    ? 5
                    : mediaUrls[i]['duration'],
              },
              token);
        } catch (err) {
          return err.toString();
        }
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<dynamic> getStories(String token) async {
    try {
      final res = await _repository.getApi('story', token);
      return res.map((e) => Stories.fromJson(e)).toList();
    } catch (err) {
      return err.toString();
    }
  }

  Future<dynamic> deleteStory(String id, String token) async {
    try {
      await _repository.delApi('story/$id', token);
    } catch (err) {
      return err.toString();
    }
  }
}
