class CommentModel {
  String name;
  String uId;
  String commentId;
  String image;
  String dateTime;
  String comment;
  String commentImage;
  CommentModel({
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.comment,
    this.commentId,
    this.commentImage

  });

  CommentModel.fromJson(Map<String, dynamic> json)
  {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    comment = json['comment'];
    commentImage = json['commentImage'];
    commentId = json['commentId'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'name':name,
      'uId':uId,
      'image':image,
      'dateTime':dateTime,
      'comment':comment,
      'commentImage':commentImage,
      'commentId':commentId,
    };
  }
}