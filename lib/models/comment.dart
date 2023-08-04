import 'package:insta_node_app/models/post.dart';

class Comment {
  String? sId;
  String? content;
  String? commentRootId;
  List<Comment>? reply;
  List<String>? likes;
  UserPost? user;
  UserPost? tag;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Comment(
      {this.sId,
      this.content,
      this.commentRootId  = '',
      this.reply,
      this.likes,
      this.user,
      this.tag,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Comment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    reply = json['reply'] != null
        ? (json['reply'] as List).map((i) => Comment.fromJson(i)).toList()
        : null;
    commentRootId = json['commentRootId'];
    likes = json['likes'].cast<String>();
    user = json['user'] != null ? new UserPost.fromJson(json['user']) : null;
    tag = json['tag'] != null ? new UserPost.fromJson(json['tag']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['content'] = this.content;
    data['reply'] = this.reply;
    data['likes'] = this.likes;
    data['commentRootId'] = this.commentRootId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.tag != null) {
      data['tag'] = this.tag!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}



