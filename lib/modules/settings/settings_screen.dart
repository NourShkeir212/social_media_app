import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/model/my_post_model.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/modules/auth/login/login_screen.dart';
import 'package:social_app/modules/following_screen/following_screen.dart';
import 'package:social_app/shared/const/consts.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/status_components/no_inernet.dart';
import 'package:social_app/shared/status_components/no_post.dart';
import 'package:social_app/shared/styles/colors.dart';
import '../../layout/app_cubit/cubit.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/comment_count_button.dart';
import '../../shared/components/components.dart';

import '../../shared/components/post_item.dart';
import '../../shared/components/show_full_image.dart';
import '../../shared/styles/icon_broken.dart';
import '../add_comment_screen/add_comments.dart';
import '../comments_screen/comments_screen.dart';
import '../edit_profile/edit_profile_screen.dart';
import 'package:conditional_builder/conditional_builder.dart';

import '../followers_screen/followers_screen.dart';
import '../like_users/like_users.dart';
import '../user_profile/user_profile.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).isInternetConnect();
        SocialCubit.get(context).myPosts=[];
        if(SocialCubit.get(context).userModel !=null){
          SocialCubit.get(context).getMyPosts();
        }

        return BlocConsumer<SocialCubit,SocialStates>(
            listener: (context,state){
              if(state is SocialDeletePostSuccessState){
                showSuccessSnackBar(context,'Delete post success');
              }
            },
            builder: (context,state)
            {
              var userModel =SocialCubit.get(context).userModel;
              return ConditionalBuilder(
                    condition: userModel != null && uId!='' ,
                    builder: (context)=> SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
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
                                      navigateTo(context, ShowFullImage(url: userModel.cover, context: context, typeOfImage: 'CoverImage'));
                                    },
                                    child: Hero(
                                      tag: 'CoverImage',
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
                                                  userModel.cover,
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
                                      navigateTo(context, ShowFullImage(url:userModel.image,context: context,typeOfImage: 'profileImage',));
                                    },
                                    child: Hero(
                                      tag: 'profileImage',
                                      child: CircleAvatar(
                                        radius: 64.0,
                                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                        child: CircleAvatar(
                                          radius: 60.0,
                                          backgroundImage: NetworkImage(
                                            userModel.image,
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
                              userModel.name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              userModel.bio,
                              style: Theme.of(context).textTheme.caption.copyWith(
                                  color: AppCubit.get(context).isDark?Colors.grey[200] : Colors.grey[500]
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){

                                      },
                                      child: Column(
                                        children:
                                        [
                                          Text(
                                            '${SocialCubit.get(context).myPosts.length}',
                                            style: Theme.of(context).textTheme.subtitle2,
                                          ),
                                          Text(
                                            'Posts',
                                            style: Theme.of(context).textTheme.caption.copyWith(
                                                color: AppCubit.get(context).isDark?Colors.grey[300] : Colors.grey[500]
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: SocialCubit.get(context).getFollowers(),
                                      builder: (context, snapshot) {
                                        return Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if(snapshot.data.docs.isEmpty){

                                              }else{
                                                navigateTo(context,FollowersScreen(snapshot));
                                              }
                                              },
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
                                    stream: SocialCubit.get(context).getFollowing(),
                                    builder: (context, snapshot) {
                                      return Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            if(snapshot.data.docs.isEmpty){

                                            }else{
                                              navigateTo(context,FollowingScreen(snapshot));
                                            }

                                          },
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
                            Row(
                              children:
                              [
                                Expanded(
                                    child: OutlinedButton(
                                      child: const Text('Sign out') ,
                                      onPressed: (){
                                       FirebaseAuth.instance.signOut().then((value){
                                         userModel=null;
                                         SocialCubit.get(context).userModel =null;
                                         uId='';
                                         CacheHelper.removeData(key: 'uId').then((value){
                                           SocialCubit.get(context).currentIndex=0;
                                           navigateAndFinish(context, LoginScreen());
                                         });
                                       });

                                      },
                                    )
                                ),
                                const SizedBox(width: 10.0,),
                                OutlinedButton(
                                  child: const Icon(
                                    IconBroken.Edit,
                                    size: 14.0,
                                  ),
                                  onPressed: (){
                                    navigateTo(context, const EditProfileScreen());
                                  },
                                )
                              ],
                            ),
                            const SizedBox(height: 20,),
                            ConditionalBuilder(
                              condition: state is! SocialGetMyPostsLoadingState,
                              fallback: (context)=>const Center(child:  CircularProgressIndicator()),
                              builder: (context) {
                                return ConditionalBuilder(
                                  condition: SocialCubit.get(context).myPosts.isNotEmpty,
                                  fallback: (context)=>Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: NoPostFound(context,isSearch: false),
                                  ),
                                  builder: (context) {
                                    return ListView.separated(
                                      itemCount: SocialCubit.get(context).myPosts.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context,index){
                                        return buildMytItem(SocialCubit.get(context).myPosts[index], context, index,userModel,state);
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
                  );
            },
        );
      }
    );
}
}

