import 'package:insta_node_app/models/post.dart';

class Reel {
  String? sId;
  String? content;
  String? videoUrl;
  List<String>? comments;
  UserPost? user;
  List<String>? likes;
  String? createdAt;
  String? updatedAt;

  Reel(
      {this.sId,
      this.content,
      this.videoUrl,
      this.comments,
      this.user,
      this.likes,
      this.createdAt,
      this.updatedAt});

  Reel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    videoUrl = json['videoUrl'];
    comments = json['comments'].cast<String>();
    user = json['user'] != null ? new UserPost.fromJson(json['user']) : null;
    likes = json['likes'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['content'] = this.content;
    data['videoUrl'] = this.videoUrl;
    data['comments'] = this.comments;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['likes'] = this.likes;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
