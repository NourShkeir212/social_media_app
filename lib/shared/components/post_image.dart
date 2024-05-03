import 'package:flutter/material.dart';
import 'package:social_app/model/my_post_model.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/shared/components/show_full_image.dart';

import 'components.dart';

Widget postImage({PostModel model,BuildContext context})=> Padding(
  padding: const EdgeInsetsDirectional.only(
      top: 5
  ),
  child: InkWell(
    onTap: (){
      navigateTo(context, ShowFullImage(url: model.postImage, context: context, typeOfImage: 'postImage'));
    },
    child: Hero(
      tag: 'postImage',
      child: Container(
        height: 140.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            4.0,
          ),
          image: DecorationImage(
            image: NetworkImage(
              model.postImage,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  ),
);


Widget postImageInSetting({MyPostsModel model,BuildContext context})=> Padding(
  padding: const EdgeInsetsDirectional.only(
      top: 3
  ),
  child: InkWell(
    onTap: (){
      navigateTo(context, ShowFullImage(url: model.postImage, context: context, typeOfImage: 'postImageInSetting'));
    },
    child: Hero(
      tag: 'postImageInSetting',
      child: Container(
        height: 140.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            4.0,
          ),
          image: DecorationImage(
            image: NetworkImage(
              model.postImage,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  ),
);

