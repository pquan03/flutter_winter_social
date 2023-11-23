import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/models/story.dart';

class Messages {
  String? sId;
  String? conversationId;
  String? senderId;
  String? recipientId;
  Post? linkPost;
  Reel? linkReel;
  Story? linkStory;
  String? text;
  List<String>? media;
  String? createdAt;
  String? updatedAt;
  Call? call;

  Messages({
    this.sId,
    this.conversationId,
    this.senderId,
    this.recipientId,
    this.text,
    this.linkPost,
    this.linkReel,
    this.linkStory,
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
    text = json['text'] ?? '';
    linkPost =
        json['linkPost'] != null ? new Post.fromJson(json['linkPost']) : null;
    linkReel =
        json['linkReel'] != null ? new Reel.fromJson(json['linkReel']) : null;
    linkStory = json['linkStory'] != null ? new Story.fromJson(json['linkStory']) : null;
    media = json['media'].cast<String>();
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
    if (this.linkPost != null) {
      data['linkPost'] = this.linkPost!.toJson();
    }
    if (this.linkReel != null) {
      data['linkReel'] = this.linkReel!.toJson();
    }
    if (this.linkStory != null) {
      data['linkStory'] = this.linkStory!.toJson();
    }
    data['media'] = this.media;
    if (this.call != null) {
      data['call'] = this.call!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
