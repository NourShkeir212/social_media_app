import 'package:flutter/material.dart';
import 'package:social_app/shared/components/post_comment_like.dart';
import 'package:social_app/shared/components/post_image.dart';

import '../../layout/cubit/states.dart';
import '../../model/my_post_model.dart';
import '../../model/post_model.dart';
import '../../model/user_model.dart';
import 'components.dart';
import 'header_post.dart';

Widget buildPostItem({
 @required PostModel model,
  @required BuildContext context,
  @required int index
}) => Card(
  clipBehavior: Clip.antiAliasWithSaveLayer,
  elevation: 5.0,
  child: Padding(
    padding: const EdgeInsets.all(
        10.0
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20,),
        buildHeaderPost(
            context: context,
            model: model,
            index: index
        ),
        myDivider(heightPadding: 8),
        ExpandableTextWidget(
          text: model.text,
          context: context,
        ),
        if(model.postImage!="")
          postImage(model: model,context: context),
        Padding(
          padding:  EdgeInsets.only(top: model.postImage!=""?0:5),
          child: commentAndLikeCountSection(context:context,postId: model.postId),
        ),
        myDivider(heightPadding: 5),
        addCommentAndLikeSection(context: context,postId: model.postId)
      ],
    ),
  ),
);

Widget buildMytItem(MyPostsModel model, context,int index,SocialUserModel userModel,SocialStates state) =>
    Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(
            10.0
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            buildHeaderPostInSetting(
                context: context,
                index: index,
                model: model,
                userModel: userModel
            ),
            myDivider(),
            ExpandableTextWidget(
              text:model.text,
              context: context,
            ),
            if(model.postImage != '')
              postImageInSetting(model: model,context: context),
            commentAndLikeCountSection(context:context,postId: model.postId),
            myDivider(heightPadding: 0),
            addCommentAndLikeSection(context: context,postId: model.postId)
          ],
        ),
      ),
    );