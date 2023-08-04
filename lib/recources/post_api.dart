

import 'dart:io';

import 'package:insta_node_app/models/post.dart' as model;
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/recources/repository.dart';
import 'package:insta_node_app/utils/image_picker.dart';

class PostApi {
  final Repository _repository = Repository();

  Future<dynamic> getPosts(String token, int page) async {
    try {
      final res = await _repository.getApi('posts?page=$page', token);
      return res.map((post)  {
        return model.Post.fromJson(post);
      }).toList();
    } catch(err) {
      return err.toString();
    }
  } 

  Future<dynamic> getPostDiscover(String token, int page) async {
    try {
      final res = await _repository.getApi('post_discover?page=$page', token);
      return res.map((post)  {
        return model.Post.fromJson(post);
      }).toList();
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> savePost(String postId, String token) async {
    try  {
      await _repository.patchApi('save_post/$postId/save', {}, token);
    } catch(err) {
      return err.toString();
    }
  }

    Future<dynamic> unSavePost(String postId, String token) async {
    try  {
      await _repository.patchApi('save_post/$postId/unsave', {}, token);
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> deletePost(String postId, String token) async {
    try {
      await _repository.delApi('posts/$postId', token);
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> likePost(String postId, String token) async {
    try {
      await _repository.patchApi('posts/$postId/like', {}, token);
    } catch(err) {
      return err.toString();
    }
  }  

  Future<dynamic> unLikePost(String postId, String token) async {
    try {
      await _repository.patchApi('posts/$postId/unlike', {}, token);
    } catch(err) {
      return err.toString();
    }
  }  

  Future<dynamic> createPost(String caption, List<File> files, String token) async {
    try {
      List<Images> images = [];
      for(int i = 0; i < files.length; i++) {
        final res = await imagePostUpload(files[i]);
        images.add(Images.fromJson(res));
      }
      final res = await _repository.postApi('posts', {
        'content': caption,
        'images': images
      }, token);
      return model.Post.fromJson(res);
    } catch(err) {
      return err.toString();
    }
  }
}