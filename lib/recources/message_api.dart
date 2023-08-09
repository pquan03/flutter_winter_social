

import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/recources/repository.dart';

class MessageApi {
  final Repository _repository = Repository();

  Future<dynamic> getConversations(String token) async {
    try {
      final res = await _repository.getApi('conversations', token);
      return res.map((e) => Conversations.fromJson(e)).toList();
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> getMessages(String conversationId, String token, int page, int limit)  async {
    try {
      final res = await _repository.getApi('messages/$conversationId?page=$page&limit=$limit', token);
      return res.map((e) => Messages.fromJson(e)).toList();
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> readMessage(String conversationId, String token) async {
    try {
      await _repository.patchApi('read_message/$conversationId/read', {}, token);
    } catch(err) {
      return err.toString();
    }
  }

    Future<dynamic> unReadMessage(String conversationId, String token) async {
    try {
      await _repository.patchApi('read_message/$conversationId/unread', {}, token);
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> createMessageText(Map<String, dynamic> data, String token) async {
    try {
      final res = await _repository.postApi('message', data, token);
      return Messages.fromJson(res['message']);
    } catch(err) {
      return err.toString();
    }
  }
}