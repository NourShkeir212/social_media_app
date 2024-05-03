import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../layout/app_cubit/cubit.dart';
import '../../../shared/components/components.dart';
import '../login/login_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController =TextEditingController();
    GlobalKey<FormState> formKey =GlobalKey<FormState>();
    return BlocProvider(
      create: (context)=>ForgotPasswordCubit(),
      child: BlocConsumer<ForgotPasswordCubit,ForgotPasswordStates>(
        listener: (context,state){
          if(state is ForgotPasswordSuccessState){
            showSuccessSnackBar(context,'Check your email');
            navigateAndFinish(
              context,
              LoginScreen(),
            );
          }
          if(state is ForgotPasswordErrorState){
           showErrorSnackBar(context, state.error.toString());
          }
        },
        builder: (context, state) {
          var cubit =ForgotPasswordCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reset Password',
                            style: Theme.of(context).textTheme.headline4.copyWith(
                              color: AppCubit.get(context).isDark?Colors.white:Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultFormField(
                            isDark: AppCubit.get(context).isDark,
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'please enter your email address';
                              }
                            },
                            label: 'Email Address',
                            prefix: Icons.email_outlined,

                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! ForgotPasswordLoadingState,
                            builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState.validate()) {
                                cubit.forgotPassword(
                                    email: emailController.text,
                                  );
                                }
                              },
                              text: 'Reset Password',
                              isUpperCase: true,
                            ),
                            fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
