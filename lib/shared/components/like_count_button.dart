import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../layout/app_cubit/cubit.dart';
import '../../layout/cubit/cubit.dart';
import '../../modules/like_users/like_users.dart';
import '../styles/icon_broken.dart';
import 'components.dart';


Widget buttonLikeCount({
 @required BuildContext context,
 @required String postId,
})=>Expanded(
  child: StreamBuilder<QuerySnapshot>(
      stream: SocialCubit.get(context).getLikesCount(postId: postId),
      builder: (context, snapshot) {
        return InkWell(
          onTap: (){
            if(snapshot.data.docs.isNotEmpty) {
              navigateTo(context, UsersLike(snapshot: snapshot));
            }
          },
          child: Row(
              children: [
                const Icon(
                  IconBroken.Heart,
                  size: 16.0,
                  color: Colors.red,
                ),
                const SizedBox(width: 3.0,),
                snapshot.hasData ? Text(
                  snapshot.data.docs.length.toString(),
                  style: Theme.of(context).textTheme.caption.copyWith(
                    color: AppCubit
                        .get(context)
                        .isDark ? Colors.white : Colors
                        .black,),
                )
                    : Text(
                  '0', style: Theme
                    .of(context)
                    .textTheme
                    .caption
                    .copyWith(
                  color: AppCubit
                      .get(context)
                      .isDark ? Colors.white : Colors.black,),
                ),
                const SizedBox(
                  width: 5.0,
                )
              ]),
        );
      }
  ),
);