import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/shared/components/post_item.dart';
import 'package:social_app/shared/components/show_full_image.dart';
import 'package:social_app/shared/styles/colors.dart';
import '../../layout/app_cubit/cubit.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/status_components/no_post.dart';
import 'package:conditional_builder/conditional_builder.dart';
class UserProfile extends StatelessWidget {
  final PostModel model;
  const UserProfile({Key key,this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        //  SocialCubit.get(context).usersPosts=[];
        //SocialCubit.get(context).getUsersPosts(userId: model.uId);
        return BlocConsumer<SocialCubit,SocialStates>(
          listener: (context,state){},
          builder: (context,state)
          {
            return Scaffold(
              appBar: defaultAppBar(context: context,title: model.name),
              body: SingleChildScrollView(
                child: ConditionalBuilder(
                  condition: model != null &&SocialCubit.get(context).userModel !=null,
                  builder: (context)=> SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                InkWell(
                                  onTap: (){
                                    navigateTo(context, ShowFullImage(url: model.cover,context: context,typeOfImage: 'userCoverImage',));
                                    },
                                  child: Hero(
                                    tag: "userCoverImage",
                                    child: Align(
                                      alignment: AlignmentDirectional.topCenter,
                                      child: Container(
                                        height: 160,
                                        width: double.infinity,
                                        decoration:  BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight:  Radius.circular(4.0),
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
                                    navigateTo(context, ShowFullImage(url: model.image, context: context, typeOfImage: 'usersProfileImage'));
                                  },
                                  child: Hero(
                                    tag: 'usersProfileImage',
                                    child: CircleAvatar(
                                      radius: 64.0,
                                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            model.name,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            model.bio,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                color: AppCubit.get(context).isDark?Colors.grey[200] : Colors.grey[500]
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical:20.0),
                            child: Row(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                    stream: SocialCubit.get(context).getUsersPostsCount(userId: model.uId),
                                    builder: (context, snapshot) {
                                      return Expanded(
                                        child: InkWell(
                                          onTap: () {},
                                          child: Column(
                                            children:
                                            [
                                              if(snapshot.hasData)
                                                Text(
                                                  snapshot.data.docs.length.toString(),
                                                  style: Theme.of(context).textTheme.caption.copyWith(
                                                    color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              if(!snapshot.hasData)
                                                Text(
                                                  '0',
                                                  style: Theme.of(context).textTheme.caption.copyWith(
                                                    color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              Text(
                                                'Posts',
                                                style: Theme.of(context).textTheme.caption.copyWith(
                                                    color: AppCubit.get(context).isDark ? Colors.grey[300] : Colors.grey[500]
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                ),
                                StreamBuilder<QuerySnapshot>(
                                    stream: SocialCubit.get(context).getUsersFollowers(userId: model.uId),
                                    builder: (context, snapshot) {
                                      return Expanded(
                                        child: InkWell(
                                          onTap: () {},
                                          child: Column(
                                            children:
                                            [
                                              if(snapshot.hasData)
                                                Text(
                                                  snapshot.data.docs.length.toString(),
                                                  style: Theme.of(context).textTheme.caption.copyWith(
                                                    color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              if(!snapshot.hasData)
                                                Text(
                                                  '0',
                                                  style: Theme.of(context).textTheme.caption.copyWith(
                                                    color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              Text(
                                                'Followers',
                                                style: Theme.of(context).textTheme.caption.copyWith(
                                                    color: AppCubit.get(context).isDark ? Colors.grey[300] : Colors.grey[500]
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                ),
                                StreamBuilder<QuerySnapshot>(
                                    stream: SocialCubit.get(context).getUsersFollowing(userId: model.uId),
                                    builder: (context, snapshot) {
                                      return Expanded(
                                        child: InkWell(
                                          onTap: () {},
                                          child: Column(
                                            children:
                                            [
                                              if(snapshot.hasData)
                                                Text(
                                                  snapshot.data.docs.length.toString(),
                                                  style: Theme.of(context).textTheme.caption.copyWith(
                                                    color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              if(!snapshot.hasData)
                                                Text(
                                                  '0',
                                                  style: Theme.of(context).textTheme.caption.copyWith(
                                                    color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              Text(
                                                'Followings',
                                                style: Theme.of(context).textTheme.caption.copyWith(
                                                    color: AppCubit.get(context).isDark ? Colors.grey[300] : Colors.grey[500]
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
                          ),
                          const SizedBox(height: 10.0,),
                          defaultButton(
                              function: (){
                                if(SocialCubit.get(context).isFollow){
                                  SocialCubit.get(context).unFollowUsers(userId: model.uId);
                                }else{
                                  SocialCubit.get(context).followUsers(userId: model.uId,userFollowImage: model.image,userFollowName: model.name,userFollowUid: model.uId);
                                }
                              },
                            isUpperCase: false,
                              text: SocialCubit.get(context).isFollow? 'Unfollow':'Follow',
                          ),
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 1.0,
                              color: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          ConditionalBuilder(
                              condition: state is! SocialGetUsersPostsLoadingState,
                              fallback: (context)=>const Center(child:  CircularProgressIndicator()),
                              builder: (context) {
                                return ConditionalBuilder(
                                    condition: SocialCubit.get(context).usersPosts.isNotEmpty,
                                    fallback: (context)=>Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: NoPostFound(context,isSearch: false),
                                    ),
                                    builder: (context) {
                                      return ListView.separated(
                                        itemCount: SocialCubit.get(context).usersPosts.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context,index){
                                          return buildPostItem(model: SocialCubit.get(context).usersPosts[index], context: context, index: index);
                                        }, separatorBuilder: (BuildContext context, int index) =>const SizedBox(height:8.0 ,),
                                      );
                                    }
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                  fallback: (context)=>const Center(child: CircularProgressIndicator(color: defaultColor,),),
                ),
              ),
            );
          },
        );
      }
    );
  }
}
