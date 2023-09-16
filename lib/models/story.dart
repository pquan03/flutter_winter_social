import 'package:insta_node_app/models/post.dart';

class Stories {
  List<Story>? stories;
  UserPost? user;

  Stories({this.stories, this.user});

  Stories.fromJson(Map<String, dynamic> json) {
    if (json['stories'] != null) {
      stories = <Story>[];
      json['stories'].forEach((v) {
        stories!.add(new Story.fromJson(v));
      });
    }
    user = json['user'] != null ? new UserPost.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stories != null) {
      data['stories'] = this.stories!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}


class Story {
  String? sId;
  UserPost? user;
  Media? media;
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
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
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
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    data['likes'] = this.likes;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Media {
  final String media;
  final int duration;
  Media({required this.media, required this.duration});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media'] = this.media;
    data['duration'] = this.duration;
    return data;
  }

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      media: json['media'],
      duration: json['duration'],
    );
  }
}