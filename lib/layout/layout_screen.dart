import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../modules/auth/login/login_screen.dart';
import '../modules/new_post/new_post_screen.dart';
import '../modules/search/search_screen.dart';
import '../shared/components/components.dart';
import '../shared/const/consts.dart';
import '../shared/network/local/cache_helper.dart';
import '../shared/styles/icon_broken.dart';
import 'app_cubit/cubit.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state)
      {
        if(state is SocialNewPostState){
          navigateTo(context, const NewPostScreen());
        }
        if(state is SocialSignOutSuccessState){
          showSuccessSnackBar(context,'Log out Success');
        }
      },
        builder: (context,state){
        var cubit =SocialCubit.get(context);

          return Scaffold(
            body: cubit.screens[cubit.currentIndex],
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              actions: [
                IconButton(
                  icon: const Icon(
                    IconBroken.Search,
                  ),
                  onPressed: () {
                    navigateTo(context,  const SearchScreen());
                  },
                ),
                IconButton(
                  icon:  const Icon(
                    Icons.brightness_4_outlined,
                  ),
                  onPressed: () {
                    AppCubit.get(context).changeAppMode();
                  },
                ),
                IconButton(
                  icon:  const Icon(
                    Icons.exit_to_app,
                  ),
                  onPressed: (){
                    FirebaseAuth.instance.signOut();
                    SocialCubit.get(context).userModel =null;
                    uId='';
                    CacheHelper.removeData(key: 'uId').then((value){
                      SocialCubit.get(context).currentIndex=0;
                      navigateAndFinish(context, LoginScreen());
                    });

                  },
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
             items: cubit.bottomItems,
             currentIndex: cubit.currentIndex,
             onTap: (int index)=>cubit.changeBottomNav(index),
            ),
          );
        },
    );
  }
}
