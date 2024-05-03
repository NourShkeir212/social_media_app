class FollowModel {
  String image;
  String name;
  String uId;

  FollowModel({
    this.name,
    this.image,
    this.uId
});
  FollowModel.fromJson(Map<String,dynamic> json)
  {
    name =json['name'];
    image =json['image'];
    uId =json['uId'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'image':image,
      'uId':uId
    };
  }

}