abstract class SocialStates{}


class SocialGetUserSuccessState extends SocialStates{}

class SocialGetUserLoadingState extends SocialStates{}

class SocialGetUserErrorState extends SocialStates{
  final String error;

  SocialGetUserErrorState(this.error);

}

class SocialInitialState extends SocialStates{}

class SocialChangeBottomNavState extends SocialStates{}

class SocialNewPostState extends SocialStates{}


class SocialProfileImagePickedSuccessState extends SocialStates{}

class SocialProfileImagePickedErrorState extends SocialStates{}

class SocialCoverImagePickedSuccessState extends SocialStates{}

class SocialCoverImagePickedErrorState extends SocialStates{}

class SocialUploadProfileImageSuccessState extends SocialStates{}

class SocialUploadProfileImageLoadingState extends SocialStates{}

class SocialUploadProfileImageErrorState extends SocialStates{
  final  String error;

  SocialUploadProfileImageErrorState(this.error);
}

class SocialUploadCoverImageSuccessState extends SocialStates{}

class SocialUploadCoverImageLoadingState extends SocialStates{}

class SocialUploadCoverImageErrorState extends SocialStates{
  final  String error;

  SocialUploadCoverImageErrorState(this.error);
}

class SocialUserUpdateErrorState extends SocialStates {
  final  String error;

  SocialUserUpdateErrorState(this.error);
}

class SocialUserUpdateLoadingState extends SocialStates{}


//create post
class SocialCreatePostSuccessState extends SocialStates{}
class SocialCreatePostEmptyState extends SocialStates{}

class SocialCreatePostLoadingState extends SocialStates{}

class SocialCreatePostErrorState extends SocialStates {
  final String error;

  SocialCreatePostErrorState(this.error);
}

class SocialPostImagePickedSuccessState extends SocialStates{}

class SocialPostImagePickedErrorState extends SocialStates{}


class SocialRemovePostImageState extends SocialStates{}


class SocialRemoveProfileImageState extends SocialStates{}

class SocialRemoveCoverImageState extends SocialStates{}

class SocialAddIdPostSuccessState extends SocialStates{}
class SocialAddIdPostErrorState extends SocialStates{
  final String error;

  SocialAddIdPostErrorState(this.error);
}

//get posts

class SocialGetPostsSuccessState extends SocialStates{}

class SocialGetPostsLoadingState extends SocialStates{}

class SocialGetPostsErrorState extends SocialStates{
  final String error;

  SocialGetPostsErrorState(this.error);

}

//like post
class SocialLikePostSuccessState extends SocialStates{}

class SocialLikePostErrorState extends SocialStates{
  final String error;

  SocialLikePostErrorState(this.error);

}

//comment post

class SocialAddCommentSuccessState extends SocialStates{}
class SocialAddCommentLoadingState extends SocialStates{}

class SocialAddCommentErrorState extends SocialStates{
  final String error;

  SocialAddCommentErrorState(this.error);

}

class SocialGetCommentLoadingState extends SocialStates{}


class SocialGetCommentSuccessState extends SocialStates{}

class SocialGetCommentErrorState extends SocialStates{
  final String error;

  SocialGetCommentErrorState(this.error);

}


//-----------------connection----------------------//

class CheckInternetConnectionMobileState extends SocialStates{}
class CheckInternetConnectionWifiState extends SocialStates{}
class CheckInternetConnectionNoneState extends SocialStates{}
class CheckInternetConnectionLoadingState extends SocialStates{}


class SocialGetLikesLoadingState extends SocialStates{}


class SocialGetLikesSuccessState extends SocialStates{}

class SocialGetAllUsersSuccessState extends SocialStates{}

class SocialGetAllUsersErrorState extends SocialStates{
  final String error;

  SocialGetAllUsersErrorState(this.error);

}

class SocialSendMessageSuccessState extends SocialStates{}

class SocialSendMessageErrorState extends SocialStates{}

class SocialGetMessagesSuccessState extends SocialStates{}

class SocialGetCommentsSuccessState extends SocialStates{}

class SocialGetCommentsErrorState extends SocialStates{}

class SocialGetCommentsLoadingState extends SocialStates{}

class SocialRemoveCommentImageState extends SocialStates{}
class SocialCommentImagePickedSuccessState extends SocialStates{}

class SocialCommentImagePickedErrorState extends SocialStates{}


class SocialGetMyPostsSuccessState extends SocialStates{}

class SocialGetMyPostsErrorState extends SocialStates{
  final String error;

  SocialGetMyPostsErrorState(this.error);
}

class SocialGetMyPostsLoadingState extends SocialStates{}


class SocialDeletePostSuccessState extends SocialStates{}

class SocialDeletePostErrorState extends SocialStates{
  final String error;

  SocialDeletePostErrorState(this.error);
}

class SocialDeletePostLoadingState extends SocialStates{}

class SocialUserUnFollowState extends SocialStates{}

class SocialUserFollowState extends SocialStates{}

class SocialSignOutState extends SocialStates{}

class SocialSignOutSuccessState extends SocialStates{}


class SocialAddLikeOnCommentLoadingState extends SocialStates{}
class SocialAddLikeOnCommentSuccessState extends SocialStates{}
class SocialAddLikeOnCommentErrorState extends SocialStates{
  final String error;
  SocialAddLikeOnCommentErrorState(this.error);
}




class SocialGetUsersPostsLoadingState extends SocialStates{}
class SocialGetUsersPostsSuccessState extends SocialStates{}
class SocialGetUsersPostsErrorState extends SocialStates{
  final String error;
  SocialGetUsersPostsErrorState(this.error);
}




class SocialSearchSuccessState extends SocialStates{}

class SocialSaveImageInLocalLoadingState extends SocialStates{}
class SocialSaveImageInLocalSuccessState extends SocialStates{}
class SocialSaveImageInLocalErrorState extends SocialStates{
  final String error;
  SocialSaveImageInLocalErrorState(this.error);
}
