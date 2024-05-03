class PostModel {
  String name;
  String postId;
  String bio;
  String cover;
  String uId;
  String image;
  String dateTime;
  String text;
  String postImage;
  PostModel({
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.text,
    this.postImage,
    this.cover,
    this.bio,
    this.postId

  });

  PostModel.fromJson(Map<String, dynamic> json)
  {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    text = json['text'];
    postImage = json['postImage'];
    cover = json['cover'];
    bio = json['bio'];
    postId = json['postId'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'name':name,
      'uId':uId,
      'image':image,
      'dateTime':dateTime,
      'text':text,
      'postImage':postImage,
      'cover':cover,
      'bio':bio,
      'postId':postId,
    };
  }
}