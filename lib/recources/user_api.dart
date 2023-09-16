

import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/models/user.dart';
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

  Future<dynamic> searchUserWithMessages(String username, String token) async {
    try {
      final res = await _repository.getApi('search_user_mess?username=$username', token);
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

  Future<dynamic> getPostProfile( String userId,String token, int page, int limit) async {
    try {
      final res = await _repository.getApi('user_posts/$userId?page=$page&limit=$limit', token);
      return res.map((e) => Post.fromJson(e)).toList();
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> getUserProfile(String userId, String token, int page, int limit) async {
    try {
      final res = await _repository.getApi('user/$userId?page=$page&limit=$limit', token);
      Map<String, dynamic> data = {
        'user': User.fromJson(res['user']),
        'posts': res['data'].map((ele) => Post.fromJson(ele)).toList(),
      };
      return data;
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> followUser(String userId, String token) async {
    try {
      await _repository.patchApi('user/$userId/follow', {}, token);
    } catch(err) {
      return err.toString();
    }
  }

    Future<dynamic> unFollowUser(String userId, String token) async {
    try {
      await _repository.patchApi('user/$userId/unfollow', {}, token);
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> getInfoListFollow(List<String> data, String token) async {
    try {
      final res = await _repository.postApi('list_user', data, token);
      return res.map((e) => UserPost.fromJson(e)).toList();
    } catch(err) {
      return err.toString();
    }
  }
}