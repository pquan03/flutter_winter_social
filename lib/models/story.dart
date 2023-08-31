import 'package:insta_node_app/models/post.dart';

class Story {
  String? sId;
  UserPost? user;
  List<String>? media;
  List<String>? likes;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Story(
      {this.sId,
      this.user,
      this.media,
      this.likes,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Story.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new UserPost.fromJson(json['user']) : null;
    media = json['media'].cast<String>(); 
    likes = json['likes'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['media'] = this.media;
    data['likes'] = this.likes;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}