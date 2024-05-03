import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import '../components/components.dart';


Widget NoInternetConnection (BuildContext context,Widget widget)=>Center(
  child:  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: 150,
        child: Image.asset(
             'assets/image/no_internet.png' ,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(height: 10.0,),
      Text(
        'Check your Internet Connection',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      const SizedBox(height: 15.0,),
      SizedBox(
        width: 100,
        child: defaultButton(function: ()
        {
         // SocialCubit.get(context).checkConnection();
         // if(SocialCubit.get(context).internet=="Internet"){
         //   navigateAndFinish(context,widget);
         // }else{
         //   showToast(text: 'No Internet', state: ToastStates.ERROR);

         }, text: 'Retry'),
      )
    ],
  ),
);

Center buildNoInternetConnection(BuildContext context,Function() onPressed) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 180,
          height: 180,
          child: Lottie.asset('assets/b.json'),
        ),
        OutlinedButton(
          onPressed: () => SocialCubit.get(context).materialOnTapButton(context,onPressed),
          child: const Text(
            "Try Again",
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12),
          ),
        )
      ],
    ),
  );
}

