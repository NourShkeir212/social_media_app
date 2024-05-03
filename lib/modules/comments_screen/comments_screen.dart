import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/status_components/no_post.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../../layout/app_cubit/cubit.dart';
import '../../model/comment_model.dart';



class CommentsScreen extends StatelessWidget {
  final String postId;

  const CommentsScreen({Key key, this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          return BlocConsumer<SocialCubit, SocialStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return Scaffold(
                    appBar: defaultAppBar(context: context, title: 'Comments'),
                    body: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection(
                                'comments').doc(postId).collection('comments')
                                .orderBy('dateTime', descending: false)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              }
                              if (snapshot.hasError) {
                                return const Center(child: Text('Error'),);
                              }
                              else {
                                List<CommentModel> comment = [];
                                snapshot.data.docs.forEach((doc) {
                                  comment.add(
                                      CommentModel.fromJson(doc.data()));
                                });
                                return ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0,
                                            bottom: 5.0,
                                            right: 8.0
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            CircleAvatar(
                                              radius: 20.0,
                                              backgroundImage: NetworkImage(
                                                  comment[index].image),
                                            ),
                                            const SizedBox(width: 10,),
                                            Flexible(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 5,
                                                    top: 5
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppCubit.get(context).isDark ? Colors.grey[800] : Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(15.0),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children:
                                                  [
                                                    Text(
                                                      comment[index].name,
                                                      maxLines: 5,
                                                      style: TextStyle(color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                          overflow: TextOverflow.ellipsis
                                                      ),
                                                    ),
                                                    if
                                                    (comment[index].commentImage != "")
                                                      SizedBox(height: 10,),
                                                    if(comment[index].commentImage != "")
                                                      Container(
                                                        height: 150,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(comment[index].commentImage)
                                                          ),
                                                        ),
                                                      )
                                                    ,
                                                    if(comment[index].commentImage != "")
                                                      const SizedBox(
                                                        height: 10,),
                                                    ExpandableTextWidget(
                                                      context: context,
                                                      text: comment[index].comment,
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 20,);
                                    },
                                    itemCount: comment.length
                                );
                              }
                            }
                        ),
                      ),
                    )
                );
              });
        });
  }
}
