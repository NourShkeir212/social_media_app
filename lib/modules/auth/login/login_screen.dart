import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/auth/login/cubit/login_cubit.dart';
import 'package:social_app/modules/auth/login/cubit/states.dart';
import 'package:social_app/shared/const/consts.dart';
import 'package:social_app/shared/status_components/no_inernet.dart';

import '../../../layout/app_cubit/cubit.dart';
import '../../../layout/cubit/cubit.dart';
import '../../../layout/layout_screen.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../forgot_password/forgot_password.dart';
import '../register/register_screen.dart';


class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var resetPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
          showErrorSnackBar(context, state.error.toString());
          }
          if (state is LoginSuccessState) {
            SocialCubit.get(context).currentIndex=0;
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              showSuccessSnackBar(context, 'Success');
              navigateAndFinish(
                context,
                const LayoutScreen(),
              );
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Builder(
                builder: (context) {
                  return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LOGIN',
                                style: Theme
                                    .of(context).textTheme.headline4
                                    .copyWith(
                                    color: AppCubit
                                        .get(context)
                                        .isDark ? Colors.white : Colors.black
                                ),
                              ),
                              Text(
                                'Login now to communicate with friends',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              defaultFormField(
                                isDark: AppCubit
                                    .get(context)
                                    .isDark,
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
                                height: 15.0,
                              ),
                              defaultFormField(
                                isDark: AppCubit
                                    .get(context)
                                    .isDark,
                                controller: passwordController,
                                type: TextInputType.visiblePassword,
                                suffix: LoginCubit
                                    .get(context)
                                    .suffix,
                                onSubmit: (value) {
                                  if (formKey.currentState.validate()) {
                                    // LoginCubit.get(context).userLogin(
                                    //   email: emailController.text,
                                    //   password: passwordController.text,
                                    // );
                                  }
                                },
                                isPassword: LoginCubit
                                    .get(context)
                                    .isPassword,
                                suffixPressed: () {
                                  LoginCubit.get(context)
                                      .changePasswordVisibility();
                                },
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'password is too short';
                                  }
                                },
                                label: 'Password',
                                prefix: Icons.lock_outline,
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              ConditionalBuilder(
                                condition: state is! LoginLoadingState,
                                builder: (context) =>
                                    defaultButton(
                                      function: () {
                                        if (formKey.currentState.validate()) {
                                          LoginCubit.get(context).userLogin(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                        }
                                      },
                                      text: 'login',
                                      isUpperCase: true,
                                    ),
                                fallback: (context) =>
                                const Center(
                                    child: CircularProgressIndicator()),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don\'t have an account?',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .subtitle1,
                                  ),
                                  defaultTextButton(
                                    function: () {
                                      navigateTo(
                                          context,
                                          SocialRegisterScreen()
                                      );
                                    },
                                    text: 'register',
                                  ),
                                ],
                              ),
                              Center(
                                child: TextButton(
                                  child: const Text("Forgot your password ?"),
                                  onPressed: () {
                                    navigateTo(
                                        context, const ForgotPasswordScreen());
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          );
        },
      ),
    );
  }
}