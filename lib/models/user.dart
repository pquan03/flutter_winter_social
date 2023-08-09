class User {
  String? sId;
  String? fullname;
  String? username;
  String? email;
  String? password;
  String? avatar;
  String? role;
  String? gender;
  String? mobile;
  String? address;
  String? story;
  String? website;
  List<String>? followers;
  List<String>? following;
  List<String>? saved;
  String? createdAt;
  String? updatedAt;
  int? countPosts;
  int? iV;

  User(
      {this.sId,
      this.fullname,
      this.username,
      this.email,
      this.password,
      this.avatar,
      this.role,
      this.gender,
      this.mobile,
      this.address,
      this.story,
      this.website,
      this.followers,
      this.following,
      this.saved,
      this.createdAt,
      this.updatedAt,
      this.countPosts,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullname = json['fullname'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    avatar = json['avatar'];
    role = json['role'];
    gender = json['gender'];
    mobile = json['mobile'];
    address = json['address'];
    story = json['story'];
    website = json['website'];
    followers = json['followers'].cast<String>();
    following = json['following'].cast<String>();
    saved = json['saved'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    countPosts = json['countPosts'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fullname'] = this.fullname;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    data['gender'] = this.gender;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['story'] = this.story;
    data['website'] = this.website;
    data['followers'] = this.followers;
    data['following'] = this.following;
    data['saved'] = this.saved;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['countPosts'] = this.countPosts;
    data['__v'] = this.iV;
    return data;
  }
}