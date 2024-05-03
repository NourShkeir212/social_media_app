import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../layout/app_cubit/cubit.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneController =TextEditingController();
    TextEditingController nameController =TextEditingController();
    TextEditingController bioController =TextEditingController();


    return BlocConsumer<SocialCubit,SocialStates>(
        listener:(context,state){},
        builder: (context,state)
        {
          var userModel =SocialCubit.get(context).userModel;
          var profileImage =SocialCubit.get(context).profileImage;
          var coverImage =SocialCubit.get(context).coverImage;

          nameController.text=userModel.name;
          bioController.text=userModel.bio;
          phoneController.text=userModel.phone;
          return   Scaffold(
            appBar: defaultAppBar(
              context: context,
              title: 'Edit Profile',
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: defaultTextButton(
                      function: (){
                        SocialCubit.get(context).updateUser(
                            name: nameController.text,
                            phone: phoneController.text,
                            bio: bioController.text,
                        );
                      },
                      text: 'Update'
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if(state is SocialUserUpdateLoadingState)
                    const LinearProgressIndicator(),
                    const SizedBox(height: 10.0,),
                    SizedBox(
                      height: 200,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children:
                              [
                                Container(
                                  height: 160,
                                  width: double.infinity,
                                  decoration:  BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight:  Radius.circular(4.0),
                                    ),
                                    image: DecorationImage(
                                        image:coverImage ==null? NetworkImage(
                                          userModel.cover,
                                        ) :FileImage(coverImage),
                                        fit: BoxFit.cover
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const CircleAvatar(
                                    radius: 20.0,
                                    child: Icon(
                                        IconBroken.Camera,
                                         size: 16.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                )
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children:
                            [
                              CircleAvatar(
                                radius: 64.0,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: profileImage == null ? NetworkImage(
                                    userModel.image,
                                  ) : FileImage(profileImage),
                                ),
                              ),
                              IconButton(
                                icon: const CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16.0,
                                  ),
                                ),
                                onPressed: ()
                                {
                                  SocialCubit.get(context).getProfileImage();
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    if(SocialCubit.get(context).profileImage !=null || SocialCubit.get(context).coverImage !=null)
                    const SizedBox(height: 20.0,),
                    if(SocialCubit.get(context).profileImage !=null || SocialCubit.get(context).coverImage !=null)
                    Row(
                      children:
                      [
                        if(SocialCubit.get(context).profileImage !=null)
                        Expanded(
                          child: Column(
                            children: [
                              defaultButton(
                                  function: (){
                                    SocialCubit.get(context).uploadProfileImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text
                                    );
                                  },
                                  text: 'upload profile',
                              ),
                            ],
                          ),
                        ),
                         const SizedBox(
                         width: 5.0,
                       ),
                        if(SocialCubit.get(context).coverImage !=null)
                        Expanded(
                          child:  Column(
                            children: [
                              defaultButton(
                                function: (){
                                  SocialCubit.get(context).uploadCoverImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text
                                  );

                                },
                                text: 'upload cover',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if(SocialCubit.get(context).profileImage !=null || SocialCubit.get(context).coverImage !=null)
                    const SizedBox(height: 20.0,),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        validate: (String value){
                          if(value.isEmpty){
                            return 'name must not be empty';
                          }else{
                            return null;
                          }
                        },
                        label: "Name",
                        prefix: IconBroken.User,
                        isDark: AppCubit.get(context).isDark
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                        controller: bioController,
                        type: TextInputType.name,
                        validate: (String value){
                          if(value.isEmpty){
                            return 'bio must not be empty';
                          }else{
                            return null;
                          }
                        },
                        label: "Bio",
                        prefix: IconBroken.Info_Circle,
                        isDark: AppCubit.get(context).isDark
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (String value){
                          if(value.isEmpty){
                            return 'phone number must not be empty';
                          }
                          else{
                            return null;
                          }
                        },
                        label: "Phone number",
                        prefix: IconBroken.Call,
                        isDark: AppCubit.get(context).isDark
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}
