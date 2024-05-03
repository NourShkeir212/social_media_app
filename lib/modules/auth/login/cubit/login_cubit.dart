import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../layout/cubit/cubit.dart';
import '../../../../model/user_model.dart';
import '../../../../shared/const/consts.dart';
import 'states.dart';


class LoginCubit extends Cubit<LoginStates>{

  LoginCubit() : super(LoginInitialState());

 static LoginCubit get(context) =>BlocProvider.of(context);


 void userLogin({
  @required String email,
  @required String password,
}){
   emit(LoginLoadingState());

   FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
     uId =value.user.uid;
     emit(LoginSuccessState(value.user.uid));
   }).catchError((error){
     emit(LoginErrorState(error.toString()));
   });
 }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordVisibilityState());
  }

  void resetPassword({
  @required String email,
    BuildContext context
}){
    emit(ResetPasswordLoadingState());
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value){
      SocialCubit.get(context).getUserData();

      emit(ResetPasswordSuccessState());
    }).catchError((error){
      emit(ResetPasswordErrorState(error: error));
    });
  }
}
