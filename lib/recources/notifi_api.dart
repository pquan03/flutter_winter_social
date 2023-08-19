

import 'package:insta_node_app/models/notify.dart';
import 'package:insta_node_app/recources/repository.dart';
import 'package:insta_node_app/utils/socket_config.dart';

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
      SocketConfig.createNotify({
        ...res,
        'user' : data['user']
      });
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> deleteNotification(String notifiId, String url, String token) async {
    try {
      final res = await _repository.delApi('notify/$notifiId?url=$url', token);
      if(res != null) {
        SocketConfig.deleteNotify(res);
      }
    } catch(err) {
      return err.toString();
    }
  }

  Future<dynamic> readNotifi(String notifiId, String token) async {
    try {
      await _repository.patchApi('isReadNotify/$notifiId', {}, token);
    } catch(err) {
      return err.toString();
    }
  }

    Future<dynamic> deleteAllNotifi(String token) async {
    try {
      await _repository.delApi('deleteAllNotfies', token);
    } catch(err) {
      return err.toString();
    }
  }
}