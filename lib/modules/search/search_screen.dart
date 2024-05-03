
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/modules/user_search_profile/user_search_profile.dart';
import 'package:social_app/shared/status_components/no_post.dart';

import '../../layout/app_cubit/cubit.dart';
import '../../layout/cubit/cubit.dart';
import '../../shared/components/components.dart';
import '../../shared/status_components/no_inernet.dart';
import '../../shared/styles/icon_broken.dart';

class  SearchScreen extends StatelessWidget {


  const SearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController =TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 5.0,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(
              IconBroken.Arrow___Left_2,
            ),
          ),
          title :Text('Search')
      ),
      body: Builder(
        builder: (context) {
          SocialCubit.get(context).isInternetConnect();
          if(searchController.text.isEmpty){
            SocialCubit.get(context).searchResult=[];
          }
          return BlocConsumer<SocialCubit, SocialStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return ConditionalBuilder(
                  condition: SocialCubit.get(context).internetConnect,
                  fallback: (context)=>buildNoInternetConnection(context,() => navigateTo(context, const SearchScreen())),
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10.0),
                                  child: TextFormField(
                                    controller: searchController,
                                    keyboardType: TextInputType.name,
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return 'Search field must not be empty';
                                      }else{
                                        return null;
                                      }
                                    },
                                    onChanged: (String value){
                                      if(value.isEmpty){

                                      }
                                      SocialCubit.get(context).searchForUser(name: value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Search',
                                      hintStyle: TextStyle(color:Colors.grey[400]),
                                      suffixIcon: IconButton(
                                        onPressed: (){
                                          if(formKey.currentState.validate()) {
                                            SocialCubit.get(context).searchForUser(
                                                name: searchController.text);
                                          }
                                        },
                                        icon: Icon(
                                          IconBroken.Search,
                                          color:AppCubit.get(context).isDark? Colors.white:Colors.black,
                                        ),
                                      ),
                                      border: const OutlineInputBorder(),
                                    ),
                                  )
                                ),
                                ConditionalBuilder(
                                  condition: searchController.text.isNotEmpty,
                                  fallback: (context)=>Container(),
                                  builder: (context) {
                                    return ConditionalBuilder(
                                      condition: SocialCubit.get(context).searchResult.isNotEmpty,
                                      builder: (context) {
                                        return ListView.separated(
                                           shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context,index){
                                             if(SocialCubit.get(context).searchResult[index].uId!=SocialCubit.get(context).userModel.uId){
                                               return buildSearchResult(SocialCubit.get(context).searchResult,context,index);
                                             }else{
                                               return Center(child: NoPostFound(context,isSearch: true,text: 'No users Found'),);
                                             }
                                            },
                                            separatorBuilder: (context,index){
                                              return myDivider();
                                            },
                                            itemCount: SocialCubit.get(context).searchResult.length
                                        );
                                      },
                                      fallback: (context)=>   Center(child: NoPostFound(context,isSearch: true,text: 'No users Found'),)
                                    );
                                  }
                                ),
                              ],
                            ),
                          )
                      );
                  }
                );
              });
        }
      )
    );
  }
  Widget buildSearchResult(List<SocialUserModel> model, context,int index,) => InkWell(
    onTap: () {
      navigateTo(context, UserSearchProfile(uId:model[index].uId,model:model[index]));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              model[index].image,
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          Text(
            model[index].name,
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
