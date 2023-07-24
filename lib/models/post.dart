import 'package:insta_node_app/models/user.dart';

class Images {
  String? publicId;
  String? url;

  Images({this.publicId, this.url});

  Images.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['public_id'] = this.publicId;
    data['url'] = this.url;
    return data;
  }
}

class UserPost {
  String? sId;
  String? fullname;
  String? username;
  String? avatar;

  UserPost({this.sId, this.fullname, this.username, this.avatar});

  UserPost.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullname = json['fullname'];
    username = json['username'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fullname'] = this.fullname;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    return data;
  }
}

class Post {
  String? sId;
  String? content;
  List<Images>? images;
  List<String>? likes;
  List<String>? comments;
  UserPost? userPost;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Post(
      {this.sId,
      this.content,
      this.images,
      this.likes,
      this.comments,
      this.userPost,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Post.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    likes = json['likes'].cast<String>();
    comments = json['comments'].cast<String>();
    userPost = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['content'] = this.content;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['likes'] = this.likes;
    data['comments'] = this.comments;
    data['user'] = this.userPost;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

