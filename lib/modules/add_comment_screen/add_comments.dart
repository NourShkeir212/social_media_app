import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../layout/app_cubit/cubit.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';

class AddCommentsScreen extends StatelessWidget {
  final String postId ;
  const AddCommentsScreen({Key key,this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextEditingController textController =TextEditingController();
    return BlocConsumer<SocialCubit,SocialStates>(
        listener: (context,state){
          if(state is SocialAddCommentErrorState){
           showErrorSnackBar(context, 'Error try again');
          }
          if(state is SocialAddCommentSuccessState){
            showSuccessSnackBar(context,'Add Comment Success');
            Navigator.pop(context);
          }
        },
        builder: (context,state){
          return BlocConsumer<SocialCubit,SocialStates>(
            listener: (context,state){},
            builder: (context,state){
              return Scaffold(
                appBar: defaultAppBar(
                  context: context,
                  title: 'Write a comment',
                  actions:
                  [
                    defaultTextButton(
                      function: (){
                        if(SocialCubit.get(context).commentImage ==null)
                        {
                          SocialCubit.get(context).addComment(
                              postId:postId,
                              comment: textController.text
                          );
                          textController.text ='';
                          if(state is SocialAddCommentSuccessState) {
                            Navigator.pop(context);
                          }
                        } else
                        {
                          SocialCubit.get(context).uploadCommentImage(
                            postId: postId,
                            text: textController.text,
                          );
                          textController.text ='';
                          if(state is SocialAddCommentSuccessState) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      text: 'Comment',
                    ),
                  ],
                ),
                body: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child:  Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            if(state is SocialAddCommentLoadingState)
                              const LinearProgressIndicator(color: defaultColor,),
                            if(state is SocialAddCommentLoadingState)
                              const SizedBox(height: 10,),
                            Row(
                              children:
                              [
                                CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage: NetworkImage(SocialCubit.get(context).userModel.image),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: Text(
                                    SocialCubit.get(context).userModel.name,
                                    style: TextStyle(
                                        height: 1.4,
                                        color: AppCubit.get(context).isDark?Colors.white : Colors.black
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0,),
                            Expanded(
                              child: TextFormField(
                                minLines: 1,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                controller: textController,
                                decoration:  InputDecoration(
                                    isCollapsed: false,
                                    filled: true,
                                    hintText: 'what is on your mind ...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        height: 1.8,
                                        color: Colors.grey[400]
                                    )
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0,),
                            if(SocialCubit.get(context).commentImage !=null)
                            Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children:
                                [
                                  Container(
                                    height: 160,
                                    width: double.infinity,
                                    decoration:  BoxDecoration(
                                      borderRadius:  BorderRadius.circular(4),
                                      image:DecorationImage(
                                          image: FileImage(SocialCubit.get(context).commentImage),
                                          fit: BoxFit.cover
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const CircleAvatar(
                                      radius: 20.0,
                                      child: Icon(
                                        Icons.close,
                                        size: 16.0,
                                      ),
                                    ),
                                    onPressed: ()
                                    {
                                      SocialCubit.get(context).removeCommentImage();
                                    },
                                  )
                                ],
                              ),
                            const SizedBox(height: 20.0,),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: (){
                                      SocialCubit.get(context).getCommentImage();
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:
                                      const [
                                        Icon(IconBroken.Image),
                                        SizedBox(width: 5.0,),
                                        Text('add photo'),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                      onPressed: (){},
                                      child: const Text('# tags')
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                ),
              );
            },
          );
        }
    );
  }
}
