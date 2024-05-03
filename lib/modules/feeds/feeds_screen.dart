import 'dart:ui';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/layout/app_cubit/cubit.dart';
import 'package:social_app/shared/status_components/no_inernet.dart';
import 'package:social_app/shared/styles/colors.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/components/post_item.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).isInternetConnect();
        SocialCubit.get(context).getUserData();
        SocialCubit.get(context).getPosts();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            int count =SocialCubit.get(context).posts.length;

            return ConditionalBuilder(
              fallback:(context)=> buildNoInternetConnection(context,() => SocialCubit.get(context).getPosts()),
              condition: SocialCubit.get(context).internetConnect,
              builder: (context) {
                return ConditionalBuilder(
                    condition: state is! SocialGetPostsLoadingState &&SocialCubit.get(context).userModel !=null && SocialCubit.get(context).posts.isNotEmpty,
                    fallback: (context)=> const Center(child: CircularProgressIndicator(),),
                    builder: (context) {
                      return RefreshIndicator(
                        onRefresh: (){
                          return SocialCubit.get(context).getPosts();
                        },
                        backgroundColor:AppCubit.get(context).isDark?HexColor('333739'):Colors.white ,
                        color:AppCubit.get(context).isDark? Colors.white:defaultColor,
                        child: ListView.separated(
                          itemCount: count,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>
                              buildPostItem(model: SocialCubit.get(context).posts[index],context: context,index: index),
                          separatorBuilder: (context, index) =>
                          const SizedBox(
                            height: 8.0,
                          ),
                        ),
                      );
                    }
                  );
              }
            );


          },
        );
      },
    );
  }

}