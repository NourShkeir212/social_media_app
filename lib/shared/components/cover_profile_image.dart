import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/show_full_image.dart';

import '../../layout/app_cubit/cubit.dart';
import '../../layout/cubit/cubit.dart';

Widget buildCoverAndProfileImage({
  @required SocialUserModel model,
  @required BuildContext context
})=>SizedBox(
  height: 200,
  child: Stack(
    alignment: AlignmentDirectional
        .bottomCenter,
    children: [
      InkWell(
        onTap: (){
          navigateTo(context, ShowFullImage(url: model.cover, context: context, typeOfImage: 'userCoverSearchImage'));
        },
        child: Hero(
          tag: 'userCoverSearchImage',
          child: Align(
            alignment: AlignmentDirectional
                .topCenter,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius
                    .only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
                image: DecorationImage(
                    image: NetworkImage(
                      model.cover,
                    ),
                    fit: BoxFit.cover
                ),
              ),
            ),
          ),
        ),
      ),
      InkWell(
        onTap: (){
          navigateTo(context, ShowFullImage(url: model.image, context: context, typeOfImage: 'userProfileSearchImage'));
        },
        child: Hero(
          tag: 'userProfileSearchImage',
          child: CircleAvatar(
            radius: 64.0,
            backgroundColor: Theme
                .of(context)
                .scaffoldBackgroundColor,
            child: CircleAvatar(
              radius: 60.0,
              backgroundImage: NetworkImage(
                model.image,
              ),
            ),
          ),
        ),
      ),
    ],
  ),
);


Widget buildFollowersAndFollowingAndPostsItem({
  @required BuildContext context,
  @required String userId,
})=>  Padding(
  padding: const EdgeInsets.symmetric(
      vertical: 20.0),
  child: Row(
    children: [
      StreamBuilder<QuerySnapshot>(
          stream: SocialCubit.get(context)
              .getUsersPostsCount(
              userId: userId),
          builder: (context, snapshot) {
            return Expanded(
              child: InkWell(
                onTap: () {},
                child: Column(
                  children:
                  [
                    if(snapshot.hasData)
                      Text(
                        snapshot.data.docs
                            .length.toString(),
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption
                            .copyWith(
                          color: AppCubit
                              .get(context)
                              .isDark ? Colors
                              .white : Colors
                              .black,
                        ),
                      ),
                    if(!snapshot.hasData)
                      Text(
                        '0',
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption
                            .copyWith(
                          color: AppCubit
                              .get(context)
                              .isDark ? Colors
                              .white : Colors
                              .black,
                        ),
                      ),
                    Text(
                      'Posts',
                      style: Theme
                          .of(context)
                          .textTheme
                          .caption
                          .copyWith(
                          color: AppCubit
                              .get(context)
                              .isDark
                              ? Colors.grey[300]
                              : Colors.grey[500]
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
      StreamBuilder<QuerySnapshot>(
          stream: SocialCubit.get(context)
              .getUsersFollowers(
              userId: userId),
          builder: (context, snapshot) {
            return Expanded(
              child: InkWell(
                onTap: () {},
                child: Column(
                  children:
                  [
                    if(snapshot.hasData)
                      Text(
                        snapshot.data.docs
                            .length.toString(),
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption
                            .copyWith(
                          color: AppCubit
                              .get(context)
                              .isDark ? Colors
                              .white : Colors
                              .black,
                        ),
                      ),
                    if(!snapshot.hasData)
                      Text(
                        '0',
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption
                            .copyWith(
                          color: AppCubit
                              .get(context)
                              .isDark ? Colors
                              .white : Colors
                              .black,
                        ),
                      ),
                    Text(
                      'Followers',
                      style: Theme
                          .of(context)
                          .textTheme
                          .caption
                          .copyWith(
                          color: AppCubit
                              .get(context)
                              .isDark
                              ? Colors.grey[300]
                              : Colors.grey[500]
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
      StreamBuilder<QuerySnapshot>(
          stream: SocialCubit.get(context)
              .getUsersFollowing(
              userId: userId),
          builder: (context, snapshot) {
            return Expanded(
              child: InkWell(
                onTap: () {},
                child: Column(
                  children:
                  [
                    if(snapshot.hasData)
                      Text(
                        snapshot.data.docs
                            .length.toString(),
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption
                            .copyWith(
                          color: AppCubit
                              .get(context)
                              .isDark ? Colors
                              .white : Colors
                              .black,
                        ),
                      ),
                    if(!snapshot.hasData)
                      Text(
                        '0',
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption
                            .copyWith(
                          color: AppCubit
                              .get(context)
                              .isDark ? Colors
                              .white : Colors
                              .black,
                        ),
                      ),
                    Text(
                      'Followings',
                      style: Theme
                          .of(context)
                          .textTheme
                          .caption
                          .copyWith(
                          color: AppCubit
                              .get(context)
                              .isDark
                              ? Colors.grey[300]
                              : Colors.grey[500]
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    ],
  ),
);