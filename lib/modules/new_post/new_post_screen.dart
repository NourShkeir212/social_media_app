import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/layout/layout_screen.dart';
import '../../layout/app_cubit/cubit.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textController =TextEditingController();
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){
        if(state is SocialCreatePostErrorState){
          showErrorSnackBar(context, 'Something went wrong. Please check your Internet Connection and try again');
        }
        if(state is SocialCreatePostSuccessState){
          showSuccessSnackBar(context, 'The post was created successfully');
        }
      },
      builder: (context,state){
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Create Post',
            actions:
            [
              if(SocialCubit.get(context).userModel!=null)
              defaultTextButton(
                  function: (){
                   var dateTime= DateFormat.yMEd().add_jms().format(Timestamp.now().toDate()).toString();

                   if(SocialCubit.get(context).postImage ==null)
                   {
                       SocialCubit.get(context).createPost(
                           dateTime: dateTime,
                           text: textController.text
                       );
                     textController.text ='';
                     if(state is! SocialCreatePostLoadingState) {
                       textController.text ='';
                       SocialCubit.get(context).currentIndex=0;
                       Navigator.pop(context);
                     }
                   } else
                   {
                     SocialCubit.get(context).uploadPostImage(
                       dateTime: dateTime,
                       text: textController.text,
                     );
                   }
                  },
                  text: 'Post'
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition:  SocialCubit.get(context).userModel!=null,
            fallback: (context)=>const Center(child: CircularProgressIndicator(),),
            builder: (context) {
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child:  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          if(state is SocialCreatePostLoadingState)
                            const LinearProgressIndicator(color: defaultColor,),
                          if(state is SocialCreatePostLoadingState)
                            const SizedBox(height: 10.0,),
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
                          const SizedBox(height: 5.0,),
                          Expanded(
                            child: TextFormField(

                              minLines: 1,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              controller: textController,
                              decoration:  InputDecoration(
                                  hintText: 'what is on your mind ...',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey[400]
                                  )
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0,),
                          if(SocialCubit.get(context).postImage !=null)
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
                                        image: FileImage(SocialCubit.get(context).postImage),
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
                                    SocialCubit.get(context).removePostImage();
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
                                    SocialCubit.get(context).getPostImage();
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
                  )
                ],

              );
            }
          ),
        );
      }
    );
  }
}
