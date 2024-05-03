import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/app_cubit/cubit.dart';
import 'package:social_app/model/user_like_model.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';


class UsersLike extends StatelessWidget {
  AsyncSnapshot<QuerySnapshot> snapshot;
  UsersLike({this.snapshot});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<UsersLikeModel>model=[];
        if(snapshot.hasData){
          for (var element in snapshot.data.docs) {
            model.add(UsersLikeModel.fromJson(element.data()));
          }
        }
        return Scaffold(
          appBar: defaultAppBar(context: context,title: 'Likes'),
          body: SingleChildScrollView(
            child: ConditionalBuilder(
              condition: model.isNotEmpty,
              builder: (context) => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => buildChatItem(model[index], context),
                separatorBuilder: (context, index) => divider(),
                itemCount: model.length,
              ),
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }

  Widget buildChatItem(UsersLikeModel model, context) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage(
            model.userImage,
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        Text(
          model.userName,
          style:  TextStyle(
              height: 1.4,
              color: AppCubit.get(context).isDark?Colors.white:Colors.black
          ),
        ),
      ],
    ),
  );
}