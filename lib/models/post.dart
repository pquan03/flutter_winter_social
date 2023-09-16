

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
  String? username;
  String? avatar;
  String? fullname;


  UserPost({this.sId, this.username, this.avatar, this.fullname = ''});

  UserPost.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    fullname = json['fullname'] ?? '';
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['fullname'] = this.fullname ?? '';
    data['avatar'] = this.avatar;
    return data;
  }
}

class Post {
  String? sId;
  String? content;
  List<String>? images;
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
      images = json['images'].cast<String>();
    }
    likes = json['likes'].cast<String>();
    comments = json['comments'].cast<String>();
    userPost = json['user'] != null ? new UserPost.fromJson(json['user']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['content'] = this.content;
    data['images'] = this.images;
    data['likes'] = this.likes;
    data['comments'] = this.comments;
    data['user'] = this.userPost;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}



class ProfilePost {
  String? sId;
  String? image;

  ProfilePost({this.sId, this.image});

  ProfilePost.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['image'] = this.image;
    return data;
  }
}