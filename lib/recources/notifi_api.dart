

import 'package:insta_node_app/models/notify.dart';
import 'package:insta_node_app/recources/repository.dart';

class NotifiApi {
  final Repository _repository = Repository();

  Future<dynamic> getNotifications(String token) async {
    try {
      final res = await _repository.getApi('notify', token);
      return res.map((e) => Notify.fromJson(e)).toList();
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> createNotification(Map<String, dynamic> data, String token) async {
    try {
      final res = await _repository.postApi('notify', data, token);
      return Notify.fromJson(res);
    } catch(err) {
      return err.toString();
    }
  }
}