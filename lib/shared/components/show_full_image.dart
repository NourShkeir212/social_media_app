import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_app/layout/app_cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../../layout/cubit/cubit.dart';

class ShowFullImage extends StatelessWidget {
  final String url;
  final BuildContext context;
  final String typeOfImage;
  const ShowFullImage({Key key,@required this.url,@required this.context,@required this.typeOfImage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SocialCubit,SocialStates>(
        listener: (context,state){
          if(state is!SocialSaveImageInLocalSuccessState){
            showSuccessSnackBar(
              context,
              'Success'
            );
          }
        },
        builder: (context,state) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Hero(
                    tag: typeOfImage,
                    child: SizedBox(
                      height: 300,
                      child: PhotoView(
                        basePosition: Alignment.center,
                        backgroundDecoration:  BoxDecoration(
                          color: AppCubit.get(context).isDark?HexColor('333739'):Colors.white,
                        ),
                        imageProvider: NetworkImage(
                          url
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                defaultButtonWithIcon(
                    function: (){
                      SocialCubit.get(context).saveImageInLocal(imgUrl: url);
                    },
                    text: 'Save to phone',
                    isUpperCase: false,
                    icon: IconBroken.Download,
                    width: 151
                )
              ],
            ),
          );
        }
      ),
    );
  }
}