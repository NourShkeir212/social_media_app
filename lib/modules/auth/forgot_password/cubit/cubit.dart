import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';



class ForgotPasswordCubit extends Cubit<ForgotPasswordStates>{

  ForgotPasswordCubit() : super(ForgotPasswordInitialState());

  static ForgotPasswordCubit get(context)=>BlocProvider.of(context);

  void forgotPassword({
  @required String email
}){
    emit(ForgotPasswordLoadingState());
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value){
      emit(ForgotPasswordSuccessState());
    }).catchError((error){
      emit(ForgotPasswordErrorState(error.toString()));
    });
  }
}