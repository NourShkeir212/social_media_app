import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../layout/app_cubit/cubit.dart';
import '../../layout/cubit/cubit.dart';
import '../../modules/comments_screen/comments_screen.dart';
import '../styles/icon_broken.dart';
import 'components.dart';


Widget buttonCommentCount({
  @required BuildContext context,
  @required String postId
})=>   Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream:  SocialCubit.get(context).getCommentsCount(postId:postId),
    builder: (context, snapshot) {
      return InkWell(
        onTap: (){
          if(snapshot.data.docs.isNotEmpty) {
            navigateTo(context, CommentsScreen(postId: postId,));
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              IconBroken.Chat,
              size: 16.0,
              color: Colors.amber,
            ),
            const SizedBox(
              width: 5.0,
            ),
                  snapshot.hasData?
                    Row(
                      children: [
                        Text('${snapshot.data.docs.length.toString()} '),
                        Text(
                          "comments".tr,
                          style:  Theme.of(context).textTheme.caption.copyWith(
                            color: AppCubit.get(context).isDark?Colors.white : Colors.black,
                          ),
                        ),

                      ],
                    ):
                    Text(
                     '0 comments'.tr,
                     style: Theme.of(context).textTheme.caption,
                 ),
          ],
        ),
      );
    }
  ),
);