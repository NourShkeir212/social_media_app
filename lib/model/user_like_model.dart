class UsersLikeModel {
  String userImage;
  String userName;
  String uId;

  UsersLikeModel({
    this.userName,
    this.userImage,
    this.uId
  });
  UsersLikeModel.fromJson(Map<String,dynamic> json)
  {
    userName =json['userName'];
    userImage =json['userImage'];
    uId =json['uId'];
  }

  Map<String,dynamic> toMap(){
    return {
      'userName':userName,
      'userImage':userImage,
      'uId':uId
    };
  }

}