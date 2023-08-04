import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/models/post.dart';

class Messages {
  String? sId;
  String? conversation;
  String? sender;
  String? recipient;
  String? text;
  List<Images>? media;
  String? createdAt;
  String? updatedAt;
  Call? call;
  int? iV;

  Messages(
      {this.sId,
      this.conversation,
      this.sender,
      this.recipient,
      this.text,
      this.media,
      this.createdAt,
      this.updatedAt,
      this.call,
      this.iV});

  Messages.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversation = json['conversation'];
    sender = json['sender'];
    recipient = json['recipient'];
    text = json['text'];
    if (json['media'] != null) {
      media = [];
      json['media'].forEach((v) {
        media!.add(new Images.fromJson(v));
      });
    } 
    call = json['call'] != null ? new Call.fromJson(json['call']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['conversation'] = this.conversation;
    data['sender'] = this.sender;
    data['recipient'] = this.recipient;
    data['text'] = this.text;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    if (this.call != null) {
      data['call'] = this.call!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}