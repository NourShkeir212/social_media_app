class MyPostsModel {
  String uId;
  String postId;
  String dateTime;
  String text;
  String postImage;
  MyPostsModel({
    this.uId,
    this.dateTime,
    this.text,
    this.postImage,
    this.postId
  });

  MyPostsModel.fromJson(Map<String, dynamic> json)
  {
    uId = json['uId'];
    dateTime = json['dateTime'];
    text = json['text'];
    postImage = json['postImage'];
    postId = json['postId'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'uId':uId,
      'dateTime':dateTime,
      'text':text,
      'postImage':postImage,
      'postId':postId,

    };
  }
}