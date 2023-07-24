
import 'user.dart';

class Auth {
  String? msg;
  String? accessToken;
  String? refreshToken;
  User? user;

  Auth({this.msg, this.accessToken, this.user});

  Auth.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}