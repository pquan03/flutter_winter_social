import 'package:insta_node_app/models/comment.dart';
import 'package:insta_node_app/recources/repository.dart';

class CommentApi {
  final Repository _repository = Repository();

  Future<dynamic> getCommentsByPostId(String postId) async {
    try {
      final res = await _repository.getApi('post_comments/$postId', null);
      return res.map((ele) => Comment.fromJson(ele)).toList();
    } catch (err) {
      return err.toString();
    }
  }

  Future<dynamic> getRepliesCommentByCommentRootId(String commentRootId) async {
    try {
      final res =
          await _repository.getApi('replies_comments/$commentRootId', null);
      return res.map((ele) => Comment.fromJson(ele)).toList();
    } catch (err) {
      return err.toString();
    }
  }

  Future<dynamic> createComment(Map<String, dynamic> data, String token) async {
    try {
      final res = await _repository.postApi('comment', data, token);
      return Comment.fromJson(res);
    } catch (err) {
      return err.toString();
    }
  }

    Future<dynamic> createReplyComment(String commentId, Map<String, dynamic> data, String token) async {
    try {
      final res = await _repository.postApi('/comment/$commentId/answer', data, token);
      return Comment.fromJson(res);
    } catch (err) {
      return err.toString();
    }
  }

  Future<dynamic> deleteComment(String postId, String commentId, String token) async {
    try {
      await _repository.delApi('comment/$commentId/post/$postId', token);
    } catch (err) {
      return err.toString();
    }
  }

  Future<dynamic> likeComment(String commentId, String token) async {
    try {
      await _repository.patchApi('comment/$commentId/like', {}, token);
    } catch (err) {
      return err.toString();
    }
  }

  Future<dynamic> unLikeComment(String commentId, String token) async {
    try {
      await _repository.patchApi('comment/$commentId/unlike', {}, token);
    } catch (err) {
      return err.toString();
    }
  }
}
