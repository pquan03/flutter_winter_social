import 'package:insta_node_app/models/post.dart';

class Conversations {
  String? sId;
  int? iV;
  String? createdAt;
  List<String>? media;
  List<UserPost>? recipients;
  bool? isRead;
  String? text;
  String? updatedAt;
  Call? call;

  Conversations(
      {this.sId,
      this.iV,
      this.createdAt,
      this.media,
      this.recipients,
      this.text,
      this.updatedAt,
      this.isRead,
      this.call});

  Conversations.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    if (json['media'] != null) {
      media = <String>[];
      json['media'].forEach((v) {
        media!.add(v);
      });
    }
    if (json['recipients'] != null) {
      recipients = <UserPost>[];
      json['recipients'].forEach((v) {
        recipients!.add(new UserPost.fromJson(v));
      });
    }
    isRead = json['isRead'];
    text = json['text'];
    updatedAt = json['updatedAt'];
    call = json['call'] != null ? new Call.fromJson(json['call']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v).toList();
    }
    if (this.recipients != null) {
      data['recipients'] = this.recipients!.map((v) => v.toJson()).toList();
    }
    data['isRead'] = this.isRead;
    data['text'] = this.text;
    data['updatedAt'] = this.updatedAt;
    if (this.call != null) {
      data['call'] = this.call!.toJson();
    }
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