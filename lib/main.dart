import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:social_app/modules/on_boarding/on_boarding.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/const/consts.dart';
import 'package:social_app/shared/localization/translation.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'layout/app_cubit/cubit.dart';
import 'layout/app_cubit/states.dart';
import 'layout/cubit/cubit.dart';
import 'layout/layout_screen.dart';
import 'modules/auth/login/login_screen.dart';



void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  await Firebase.initializeApp();
  Widget widget;
  bool isDark = CacheHelper.getData(key: 'isDark');
  uId = CacheHelper.getData(key: 'uId');
   on_board=CacheHelper.getData(key: 'onBoarding');
  print(uId);
  if(on_board==true){
    widget =uId==null? LoginScreen():const LayoutScreen();
  }else{
    widget=OnBoardingScreen();
  }


  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  final bool isDark;
  const MyApp({Key key,this.startWidget,this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:[
        BlocProvider(
        create: (BuildContext context) => SocialCubit()..getUserData()
        ),
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
      ],
      child:BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          return GetMaterialApp(
            translations: Translation(),
            locale: const Locale('en'),
            fallbackLocale: const Locale('en'),
            darkTheme: darkTheme,
            theme: lightTheme,
          themeMode:AppCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light,
            debugShowCheckedModeBanner: false,
           home: startWidget,

          );
        },
      ),
    );
  }
}
