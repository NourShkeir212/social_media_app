import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/model/my_post_model.dart';
import 'package:social_app/model/user_model.dart';

import '../../layout/app_cubit/cubit.dart';
import '../../layout/cubit/cubit.dart';
import '../../model/post_model.dart';
import '../../modules/like_users/like_users.dart';
import '../../modules/user_profile/user_profile.dart';
import '../styles/colors.dart';
import '../styles/icon_broken.dart';
import 'components.dart';


Widget buildHeaderPostInSetting({
  @required BuildContext context,
  @required SocialUserModel userModel,
  @required MyPostsModel model,
  @required int index,
})=>Row(
  children: [
    CircleAvatar(
      radius: 25.0,
      backgroundImage: NetworkImage(
        userModel.image,
      ),
    ),
    const SizedBox(
      width: 15.0,
    ),
    Expanded(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              userModel.name,
              style:  TextStyle(
                  height: 1.4,
                  color: AppCubit.get(context).isDark?Colors.white : Colors.black
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            const Icon(
              Icons.check_circle,
              color: defaultColor,
              size: 16.0,
            ),
          ],
        ),
        Text(
          model.dateTime,
          style: Theme.of(context).textTheme.caption.copyWith(
              height: 1.4,
              color: Colors.grey[400]
          ),
        ),
      ],
    ),),
    const SizedBox(
      width: 15.0,
    ),
    IconButton(
      icon:  Icon(
        IconBroken.Delete,
        color: AppCubit.get(context).isDark?Colors.white : Colors.black,
        size: 16.0,
      ),
      onPressed: () {
        SocialCubit.get(context).deletePost(SocialCubit.get(context).postsId[index]);
      },
    ),
  ],
);


Widget buildHeaderPost({
  @required BuildContext context,
  @required PostModel model,
  @required int index,
})=>Row(
  children: [
    InkWell(
      onTap: (){
        if(model.uId==SocialCubit.get(context).userModel.uId){
        }else{
          SocialCubit.get(context).usersPosts=[];
          SocialCubit.get(context).getUsersPosts(userId: model.uId);
          navigateTo(context, UserProfile(model: model));
        }
      },
      child: CircleAvatar(
        radius: 25.0,
        backgroundImage: NetworkImage(
          model.image,
        ),
      ),
    ),
    const SizedBox(
      width: 15.0,
    ),
    Expanded(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              model.name,
              style:  TextStyle(
                  height: 1.4,
                  color: AppCubit.get(context).isDark?Colors.white : Colors.black
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            const Icon(
              Icons.check_circle,
              color: defaultColor,
              size: 16.0,
            ),
          ],
        ),
        Text(
          model.dateTime,
          style: Theme.of(context).textTheme.caption.copyWith(
              height: 1.4,
              color: Colors.grey[400]
          ),
        ),
      ],
    ),),
    const SizedBox(
      width: 15.0,
    ),
    IconButton(
      icon:  Icon(
        Icons.more_horiz,
        color: AppCubit.get(context).isDark?Colors.white : Colors.black,
        size: 16.0,
      ),
      onPressed: () {},
    ),
  ],
);