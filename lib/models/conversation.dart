import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/models/post.dart';

class Conversations {
  String? sId;
  String? createdAt;
  List<UserPost>? recipients;
  List<Messages>? messages;
  bool? isRead;
  String? updatedAt;

  Conversations(
      {this.sId,
      this.createdAt,
      this.recipients,
      this.messages,
      this.updatedAt,
      this.isRead,
      });

  Conversations.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['createdAt'];
    if (json['recipients'] != null) {
      recipients = <UserPost>[];
      json['recipients'].forEach((v) {
        recipients!.add(new UserPost.fromJson(v));
      });
    }
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
    isRead = json['isRead'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    if (this.recipients != null) {
      data['recipients'] = this.recipients!.map((v) => v.toJson()).toList();
    }
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    data['isRead'] = this.isRead;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Call {
  bool? video;
  int? times;

  Call({this.video, this.times});

  Call.fromJson(Map<String, dynamic> json) {
    video = json['video'];
    times = json['times'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video'] = this.video;
    data['times'] = this.times;
    return data;
  }
}