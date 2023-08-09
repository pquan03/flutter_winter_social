import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/models/post.dart';

class Messages {
  String? sId;
  String? conversationId;
  String? senderId;
  String? recipientId;
  String? linkPost;
  String? text;
  List<Images>? media;
  String? createdAt;
  String? updatedAt;
  Call? call;

  Messages(
      {this.sId,
      this.conversationId,
      this.senderId,
      this.recipientId,
      this.text,
      this.linkPost,
      this.media,
      this.createdAt,
      this.updatedAt,
      this.call,
      });

  Messages.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversationId = json['conversationId'];
    senderId = json['senderId'];
    recipientId = json['recipientId'];
    text = json['text'];
    linkPost = json['linkPost'];
    if (json['media'] != null) {
      media = [];
      json['media'].forEach((v) {
        media!.add(new Images.fromJson(v));
      });
    } 
    call = json['call'] != null ? new Call.fromJson(json['call']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['conversationId'] = this.conversationId;
    data['senderId'] = this.senderId;
    data['recipientId'] = this.recipientId;
    data['text'] = this.text;
    data['linkPost'] = this.linkPost;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    if (this.call != null) {
      data['call'] = this.call!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}