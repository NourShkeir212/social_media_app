import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../layout/cubit/cubit.dart';
import '../../modules/add_comment_screen/add_comments.dart';
import 'comment_count_button.dart';
import 'components.dart';
import 'like_count_button.dart';

Widget commentAndLikeCountSection({
  @required String postId,
  @required BuildContext context,
})=>Padding(
  padding:  const EdgeInsets.only(
    top:5,
    bottom: 5
  ),
  child: Row(
    children: [
      buttonLikeCount(
          postId: postId,
          context: context
      ),
      buttonCommentCount(
        postId:postId,
        context: context,
      )
    ],
  ),
);


Widget addCommentAndLikeSection({
  @required BuildContext context,
  @required String postId,
})=>Row(
  children: [
    Expanded(
      child: InkWell(
        child: Row(
          children: [
            CircleAvatar(
              radius: 18.0,
              backgroundImage: NetworkImage(
                SocialCubit
                    .get(context)
                    .userModel
                    .image,
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Text(
                'write a comment ...'.tr,
                style:Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.grey[300]
                )
            ),
          ],
        ),
        onTap: () {
          navigateTo(context, AddCommentsScreen(postId:postId,));
        },
      ),
    ),
    StreamBuilder<DocumentSnapshot>(
        stream: SocialCubit.get(context).likeButtonChange(postId: postId),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return const Center(child: Icon(FontAwesomeIcons.heart),);
          }
          if (snapshots.data.exists) {
            return IconButton(
              onPressed: () {
                SocialCubit.get(context).addLike(true, postId: postId);
              },
              icon: const Icon(FontAwesomeIcons.solidHeart, size: 16,),
              color: Colors.red,
            );
          } else {
            return IconButton(
              onPressed: () {
                SocialCubit.get(context).addLike(false, postId: postId);
              },
              icon: const Icon(FontAwesomeIcons.heart, size: 16,),
              color: Colors.red,
            );
          }
        }
    ),
  ],
);