import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/app_cubit/cubit.dart';
import 'package:social_app/shared/status_components/no_inernet.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../model/user_model.dart';
import '../../shared/components/components.dart';
import '../chat_detail/chat_details_screen.dart';


class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Builder(

          builder: (context) {
            SocialCubit.get(context).isInternetConnect();
            return ConditionalBuilder(
              condition: SocialCubit.get(context).internetConnect,
              fallback: (context)=>buildNoInternetConnection(context,() => SocialCubit.get(context).getUsers()),
              builder: (context) {
                return ConditionalBuilder(
                  condition: SocialCubit.get(context).users.isNotEmpty,
                  builder: (context) => ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildChatItem(SocialCubit.get(context).users[index], context),
                    separatorBuilder: (context, index) => divider(),
                    itemCount: SocialCubit.get(context).users.length,
                  ),
                  fallback: (context) => const Center(child: CircularProgressIndicator()),
                );
              }
            );
          }
        );
      },
    );
  }

  Widget buildChatItem(SocialUserModel model, context) => InkWell(
    onTap: () {
      navigateTo(
        context,
        ChatDetailsScreen(
          userModel: model,
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              model.image,
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          Text(
            model.name,
            style:  TextStyle(
              height: 1.4,
              color: AppCubit.get(context).isDark?Colors.white:Colors.black
            ),
          ),
        ],
      ),
    ),
  );
}