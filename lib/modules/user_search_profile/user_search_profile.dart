import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/components/post_item.dart';
import 'package:social_app/shared/styles/colors.dart';
import '../../layout/app_cubit/cubit.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/components/cover_profile_image.dart';
import '../../shared/status_components/no_post.dart';
import 'package:conditional_builder/conditional_builder.dart';
class UserSearchProfile extends StatelessWidget {
 final String uId;
 final SocialUserModel model;
  const UserSearchProfile({Key key,this.uId,this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                appBar: defaultAppBar(context: context, title: model.name),
                body: SingleChildScrollView(
                  child: ConditionalBuilder(
                    condition: model != null,
                    builder: (context) =>
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                buildCoverAndProfileImage(model: model,context: context),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  model.name, style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  model.bio,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                      color: AppCubit
                                          .get(context)
                                          .isDark ? Colors.grey[200] : Colors
                                          .grey[500]
                                  ),
                                ),
                                buildFollowersAndFollowingAndPostsItem(context: context,userId: model.uId),                                const SizedBox(height: 10.0,),
                                defaultButton(
                                  function: () {
                                    if (SocialCubit
                                        .get(context)
                                        .isFollow) {
                                      SocialCubit.get(context).unFollowUsers(
                                          userId: model.uId);
                                    } else {
                                      SocialCubit.get(context).followUsers(userId: model.uId, userFollowImage: model.image, userFollowName: model.name, userFollowUid: model.uId);
                                    }
                                  },
                                  isUpperCase: false,
                                  text: SocialCubit.get(context).isFollow ? 'Unfollow' : 'Follow',
                                ),
                                const SizedBox(height: 20,),
                                myDivider(),
                                const SizedBox(height: 10,),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('posts').where('uId',isEqualTo: uId).snapshots(),
                                  builder: (context, snapshot) {
                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return const CircularProgressIndicator();
                                      }
                                      if(snapshot.hasData) {
                                        List<PostModel> postModel =[];
                                        for (var element in snapshot.data.docs) {
                                          postModel.add(PostModel.fromJson(element.data()));
                                        }
                                        return ListView.separated(
                                          itemCount: snapshot.data.docs.length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return buildPostItem(model: postModel[index], context: context, index: index);
                                          },
                                          separatorBuilder: (
                                              BuildContext context,
                                              int index) =>
                                          const SizedBox(height: 8.0,),
                                        );
                                      }else{
                                        return Center(child: NoPostFound(context,isSearch: false),);
                                      }
                                  }
                                ),
                              ],
                            ),
                          ),
                        ),
                    fallback: (context) =>
                    const Center(
                      child: CircularProgressIndicator(color: defaultColor,),),
                  ),
                ),
              );
            },
          );
        }
    );
  }
}
