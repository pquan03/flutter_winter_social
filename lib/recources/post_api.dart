

import 'package:insta_node_app/models/post.dart' as model;
import 'package:insta_node_app/recources/repository.dart';

class PostApi {
  final Repository _repository = Repository();

  Future<dynamic> getPosts(String token) async {
    try {
      final res = await _repository.getApi('posts', token);
      final data =  res.map((post)  {
        return model.Post.fromJson(post);
      }).toList();
      print('data: $data.toString()');
      return data;
    } catch(err) {
      return err.toString();
    }
  } 
}