import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../model/my_post_model.dart';
import '../../shared/components/components.dart';
import 'states.dart';
import '../../model/comment_model.dart';
import '../../model/message_model.dart';
import '../../model/post_model.dart';
import '../../model/user_model.dart';
import '../../modules/chats/chats_screen.dart';
import '../../modules/feeds/feeds_screen.dart';
import '../../modules/new_post/new_post_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../modules/users/users_screen.dart';
import '../../shared/const/consts.dart';
import '../../shared/styles/icon_broken.dart';
import 'package:get/get.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);


  List<BottomNavigationBarItem> bottomItems = [
     BottomNavigationBarItem(
      icon: const Icon(
        IconBroken.Home,
      ),
      label: 'Home'.tr,
    ),
     BottomNavigationBarItem(
      icon: const Icon(
        IconBroken.Chat,
      ),
      label: 'Chats'.tr,
    ),
     BottomNavigationBarItem(
      icon: const Icon(
        IconBroken.Paper_Upload,
      ),
      label: 'Post'.tr,
    ),
     BottomNavigationBarItem(
      icon: const Icon(
        IconBroken.Location,
      ),
      label: 'Users'.tr,
    ),
     BottomNavigationBarItem(
      icon: const Icon(
        IconBroken.Profile,
      ),
      label: 'My Profile'.tr,
    ),
  ];

  SocialUserModel userModel;

  void getUserData() {
    userModel = null;
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      //print(value.data());
      userModel = SocialUserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    const NewPostScreen(),
    const UsersScreen(),
    const SettingsScreen(),
  ];

  List<String> titles = [
    'Home'.tr,
    'Chats'.tr,
    'Post'.tr,
    'Users'.tr,
    'MyProfile'.tr,
  ];

  void changeBottomNav(int index) {
    if (index == 4) {
      myPosts = [];
    }
    if (index == 0) {
      posts.clear();
      getPosts();
    }
    if (index == 1) {
      users = [];
      getUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    }
    else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }
  bool internetConnect = true;
  isInternetConnect() async {
    internetConnect  = await InternetConnectionChecker().hasConnection;
  }

  void materialOnTapButton(BuildContext context,Function() onPressed) async {
    if (await InternetConnectionChecker().hasConnection == true) {
      onPressed();
    } else {
      showErrorSnackBar(context,'Something went wrong. Please check your Internet Connection and try again');
    }
  }

  File profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  // image_picker7901250412914563370.jpg

  File coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void removeProfileImage() {
    profileImage = null;
    emit(SocialRemoveProfileImageState());
  }

  void uploadProfileImage({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(profileImage.path)
        .pathSegments
        .last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadProfileImageSuccessState());
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
        getUserData();
        removeProfileImage();
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState(error.toString()));
    });
  }

  void removeCoverImage() {
    coverImage = null;
    emit(SocialRemoveCoverImageState());
  }

  void uploadCoverImage({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(coverImage.path)
        .pathSegments
        .last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadCoverImageSuccessState());
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState(error.toString()));
    });
  }


  void updateUser({
    @required String name,
    @required String phone,
    @required String bio,
    String cover,
    String image,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel.email,
      cover: cover ?? userModel.cover,
      image: image ?? userModel.image,
      uId: userModel.uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState(error.toString()));
    });
  }

  File postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    @required String dateTime,
    @required String text,
  }) {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri
        .file(postImage.path)
        .pathSegments
        .last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
        );
        //getUsersPosts();
      }).catchError((error) {
        emit(SocialCreatePostErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState(error.toString()));
    });
  }

  void createPost({
    @required String dateTime,
    @required String text,
    String postImage,
  }) {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(

      name: userModel.name,
      image: userModel.image,
      uId: userModel.uId,
      cover: userModel.cover,
      bio: userModel.bio,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
      value.update({
        'postId': value.id
      });
      posts = [];
      postsId = [];
      getPosts();
      myPosts = [];
    }).catchError((error) {
      emit(SocialCreatePostErrorState(error.toString()));
    });
  }

  List<SocialUserModel> users = [];

  void getUsers() {
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel.uId) {
            users.add(SocialUserModel.fromJson(element.data()));
          }
        });
        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetAllUsersErrorState(error.toString()));
      });
    }
  }


  //------------------------------for chat------------------------------//

  void sendMessage({
    @required String receiverId,
    @required String dateTime,
    @required String text,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    // set my chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    // set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    @required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });

      emit(SocialGetMessagesSuccessState());
    });
  }


  //---------------------like----------------------//

  void addLike(bool liked, {String postId}) {
    liked = !liked;
    if (liked) {
      FirebaseFirestore.instance
          .collection('likes')
          .doc(postId)
          .collection('likes').
      doc(userModel.uId).set({
        'userName': userModel.name,
        'userImage': userModel.image,
        'createDate': DateFormat.yMEd().add_jms()
            .format(DateTime.now())
            .toString()
      });
    } else {
      DocumentReference ref = FirebaseFirestore.instance
          .collection('likes')
          .doc(postId)
          .collection('likes').
      doc(userModel.uId);
      ref.delete();
    }
  }


  Stream<DocumentSnapshot> likeButtonChange({String postId}) {
    var doc = FirebaseFirestore.instance
        .collection('likes')
        .doc(postId)
        .collection('likes')
        .doc(userModel.uId)
        .snapshots();
    return doc;
  }

  List<CommentModel> usersComments = [];


  List<PostModel> posts = [];

  Future<void> getPosts() async {
    isInternetConnect();
    emit(SocialGetPostsLoadingState());
    posts = [];

    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      posts = [];
      event.docs.forEach((element) {
        posts.add(PostModel.fromJson(element.data()));
        postsId.add(element.id);
        emit(SocialGetPostsSuccessState());
      });
    });
  }

  List<PostModel> usersPosts = [];

  void getUsersPosts({String userId}) {
    emit(SocialGetUsersPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .where('uId', isEqualTo: userId)
        .snapshots()
        .listen((event) {
      for (var element in event.docs) {
        usersPosts.add(PostModel.fromJson(element.data()));
        emit(SocialGetUsersPostsSuccessState());
      }
    }).onError((error) {
      emit(SocialGetUsersPostsErrorState(error.toString()));
    });
  }


  List<String> postsId = [];
  List<MyPostsModel> myPosts = [];

  void getMyPosts() {
    emit(SocialGetMyPostsLoadingState());
    if(userModel.uId.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('posts')
          .where('uId', isEqualTo: userModel.uId)
          .snapshots()
          .listen((event) {
        event.docs.forEach((element) {
          myPosts.add(MyPostsModel.fromJson(element.data()));
          emit(SocialGetMyPostsSuccessState());
        });
      }).onError((error) {
        emit(SocialGetMyPostsErrorState(error.toString()));
      });
    }else{

    }
  }

  void deletePost(String postId) {
    emit(SocialDeletePostLoadingState());
    FirebaseFirestore.instance
        .collection("posts")
        .where("postId", isEqualTo: postId)
        .get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection("posts").doc(element.id)
            .delete()
            .then((value) {
          myPosts = [];
          getMyPosts();
          emit(SocialDeletePostSuccessState());
        }).catchError((error) {
          emit(SocialDeletePostErrorState(error.toString()));
        });
      });
    });
  }

  bool isFollow = false;
  String title = 'follow';


  signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }


  //----------------Followers and Following-------------------//


  void unFollowUsers({String userId}) {
    isFollow = false;
    title = 'follow';
    emit(SocialUserUnFollowState());
    FirebaseFirestore.instance.collection('followers')
        .doc(userId)
        .collection('userFollowers')
        .doc(userModel.uId)
        .get().then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });
    FirebaseFirestore.instance
        .collection('following')
        .doc(userModel.uId)
        .collection('userFollowing')
        .doc(userId)
        .get().then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });
    // FirebaseFirestore.instance.collection('posts')
    // .doc(userId)
    // .collection('postsItems')
    // .doc(userModel.uId)
    // .set({
    //   'type' :'followers',
    //   'userId':userModel.uId,
    //   'userName':userModel.name,
    //
    // });
  }

  void followUsers(
      {String userId, String userFollowName, String userFollowImage, userFollowUid}) {
    isFollow = true;
    title = 'unfollow';
    emit(SocialUserFollowState());
    FirebaseFirestore.instance.collection('followers')
        .doc(userId)
        .collection('userFollowers')
        .doc(userModel.uId)
        .set({
      'name': userModel.name,
      'image': userModel.image,
      'uId': userModel.uId
    });
    FirebaseFirestore.instance
        .collection('following')
        .doc(userModel.uId)
        .collection('userFollowing')
        .doc(userId)
        .set({
      'name': userFollowName,
      'image': userFollowImage,
      'uId': userFollowUid,
    });
  }

  Stream<QuerySnapshot> getFollowing() {
    var query = FirebaseFirestore.instance
        .collection('following')
        .doc(userModel.uId)
        .collection('userFollowing')
        .snapshots();
    return query;
  }

  Stream<QuerySnapshot> getFollowers() {
    var query = FirebaseFirestore.instance
        .collection('followers')
        .doc(userModel.uId)
        .collection('userFollowers')
        .snapshots();
    return query;
  }

  Stream<QuerySnapshot> getUsersFollowing({String userId}) {
    var query = FirebaseFirestore.instance
        .collection('following')
        .doc(userId)
        .collection('userFollowing')
        .snapshots();
    return query;
  }

  Stream<QuerySnapshot> getUsersFollowers({String userId}) {
    var query = FirebaseFirestore.instance
        .collection('followers')
        .doc(userId)
        .collection('userFollowers')
        .snapshots();
    return query;
  }

  Stream<QuerySnapshot> getUsersPostsCount({String userId}) {
    var query = FirebaseFirestore.instance
        .collection('posts')
        .where('uId', isEqualTo: userId)
        .snapshots();
    return query;
  }

  // Stream<QuerySnapshot> getUsersPosts({String userId}) {
  //   var ref=  FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('uId', isEqualTo: userId)
  //         .snapshots();
  //   return ref;
  // }

  //--------------------------for comment--------------------------//

  addComment({String postId, String comment, String commentImage}) {
    CommentModel model = CommentModel(
      uId: userModel.uId,
      dateTime: DateFormat.yMEd().add_jms()
          .format(Timestamp.now().toDate())
          .toString(),
      comment: comment,
      name: userModel.name,
      image: userModel.image,
      commentImage: commentImage ?? '',
    );
    emit(SocialAddCommentLoadingState());
    FirebaseFirestore.instance
        .collection('comments')
        .doc(postId)
        .collection('comments')
        .add(model.toMap()).then((value) {
      FirebaseFirestore.instance.collection('comments')
          .doc(postId)
          .collection('comments')
          .doc(value.id)
          .update({
        "commentId": value.id
      });
      emit(SocialAddCommentSuccessState());
    }).catchError((error) {
      emit(SocialAddCommentErrorState(error.toString()));
    });
  }


  Stream<QuerySnapshot> getCommentsCount({String postId}) {
    var query = FirebaseFirestore.instance
        .collection('comments')
        .doc(postId)
        .collection('comments')
        .snapshots();
    return query;
  }

  Stream<QuerySnapshot> getLikesCount({String postId}) {
    var query = FirebaseFirestore.instance
        .collection('likes')
        .doc(postId)
        .collection('likes')
        .snapshots();
    return query;
  }

  File commentImage;

  void uploadCommentImage({
    @required String text,
    @required String postId,
  }) {
    emit(SocialAddCommentLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('comments/${Uri
        .file(commentImage.path)
        .pathSegments
        .last}')
        .putFile(commentImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        addComment(
            postId: postId,
            comment: text,
            commentImage: value
        );
        removeCommentImage();
      }).catchError((error) {
        emit(SocialAddCommentErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialAddCommentErrorState(error.toString()));
    });
  }

  Future<void> getCommentImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      emit(SocialCommentImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCommentImagePickedErrorState());
    }
  }

  void removeCommentImage() {
    commentImage = null;
    emit(SocialRemoveCommentImageState());
  }

  List<SocialUserModel> searchResult = [];

  void searchForUser({@required String name}) {
    name.isNotEmpty ? FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name).snapshots()
        .listen((event) {
          searchResult=[];
      event.docs.forEach((element) {
        searchResult.add(SocialUserModel.fromJson(element.data()));
        emit(SocialSearchSuccessState());
      });
    })
        : FirebaseFirestore.instance.collection('users').snapshots();
  }


  void saveImageInLocal({String imgUrl}){
    emit(SocialSaveImageInLocalLoadingState());
    ImageDownloader.downloadImage(
        imgUrl,
        destination: AndroidDestinationType.directoryDCIM..subDirectory('Picture/${Uri.file(imgUrl).pathSegments.last}')
    ).then((value){
      emit(SocialSaveImageInLocalSuccessState());
    }).catchError((error){
      emit(SocialSaveImageInLocalErrorState(error.toString()));
    });
  }
  }


















//old comment


//---------------------like----------------------//

// void addComment({
//   String postId,
//   String comment,
//   String commentImage,
// }){
//
//   CommentModel commentModel =CommentModel(
//     image: userModel.image,
//     name: userModel.name,
//     comment: comment,
//     dateTime: DateFormat.yMEd().add_jms().format(DateTime.now()).toString(),
//     uId: userModel.uId,
//     commentImage: commentImage ?? '',
//   );
//
//   emit(SocialAddCommentLoadingState());
//   var  ref =FirebaseFirestore.instance
//       .collection('posts')
//       .doc(postId)
//       .collection('comments')
//       .add(commentModel.toMap()).then((value)
//   {
//     emit(SocialAddCommentSuccessState());
//   }).catchError((error){
//     emit(SocialAddCommentErrorState(error.toString()));
//   });
// }

// Stream<QuerySnapshot> getCommentsCount({String postId}){
//   var query= FirebaseFirestore.instance
//       .collection('posts')
//       .doc(postId)
//       .collection('comments')
//       .snapshots();
//   return query;
// }
// void getUsersComments({String postId}){
//   emit(SocialGetCommentsLoadingState());
//   usersComments=[];
//
//   FirebaseFirestore.instance
//       .collection('posts')
//       .doc(postId)
//       .collection('comments')
//       .snapshots()
//       .listen((event) {
//     usersComments=[];
//     event.docs.forEach((element) {
//       usersComments.add(CommentModel.fromJson(element.data()));
//       emit(SocialGetCommentsSuccessState());
//     });
//   });
// }