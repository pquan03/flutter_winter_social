import 'package:insta_node_app/models/post.dart';

class Notify {
  String? sId;
  String? id;
  UserPost? user;
  List<String>? recipients;
  String? url;
  String? text;
  String? content;
  String? image;
  bool? isRead;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Notify(
      {this.sId,
      this.id,
      this.user,
      this.recipients,
      this.url,
      this.text,
      this.content,
      this.image,
      this.isRead,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Notify.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    user = json['user'] != null ? new UserPost.fromJson(json['user']) : null;
    recipients = json['recipients'].cast<String>();
    url = json['url'];
    text = json['text'];
    content = json['content'];
    image = json['image'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['recipients'] = this.recipients;
    data['url'] = this.url;
    data['text'] = this.text;
    data['content'] = this.content;
    data['image'] = this.image;
    data['isRead'] = this.isRead;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}