import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



import 'states.dart';
import '../../shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit() : super(AppInitialState());

 static AppCubit get(context)=>BlocProvider.of(context);


  bool isDark = true;


  IconData themeModeIcon =Icons.light_mode_outlined;

  void changeAppMode({bool fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        themeModeIcon =isDark ?Icons.dark_mode_outlined:Icons.light_mode_outlined;
        emit(AppChangeModeState());

      });
    }
  }

}