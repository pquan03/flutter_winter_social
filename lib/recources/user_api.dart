

import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/recources/repository.dart';

class UserApi {
  final Repository _repository = Repository();

  Future<dynamic> searchUser(String username, String token) async {
    try {
      final res = await _repository.getApi('search?username=$username', token);
      return res.map((e) => UserPost.fromJson(e)).toList();
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> updateUser(Map<String , dynamic> data, String token) async {
    try {
      await _repository.patchApi('user', data, token);
    } catch(err) {
      return err.toString();
    }
  }
}