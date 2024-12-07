import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_crm_app/core/constants/exports.dart';

import '../../../../config/routes/names.dart';
import '../../../../config/theme/colors.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/resources/shared_event.dart';
import '../../../../core/util/controller/sign_in_controller.dart';
import '../../../../injection_container.dart';
import '../bloc/sign_in/sign_in_bloc.dart';
import '../widgets/AnimatedText.dart';
import '../widgets/common_widgets.dart';
import '../widgets/sign_up_widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final SignInController _signInController = SignInController();
  late SignInBloc _signInBloc;
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _signInBloc = BlocProvider.of<SignInBloc>(context);
  // }

  @override
  void dispose() {
    _signInBloc.add(SignInReset());
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      sl<StorageServices>().setBool(AppConstant.STORAGE_USER_TOKEN_KEY, true);
      _signInBloc.add(SignInSubmitEvent(
          email: _signInController.emailController.text,
          password: _signInController.passwordController.text));
    }
  }

  void _handleGoogleSignIn() {
    sl<StorageServices>().setBool(AppConstant.STORAGE_USER_TOKEN_KEY, true);
    _signInBloc.add(GoogleSignInEvent());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:
          AppColors.secondaryColor, // Set status bar color for home screen
      statusBarIconBrightness: Brightness.light, // Light text/icons
    ));
    return BlocListener<SignInBloc, SignInState>(listener: (context, state) {
      if (state.signInSuccess || state.isGoogleSignInSuccess) {
        print("Successfully Signed in: ${state.email}");
        // context.read<SignUpBloc>().add(SignUpLoadingEvent());

        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.MAIN, (Route<dynamic> route) => false);
      }
      if (state.signInFailure != null || state.googleSignInFailure != null) {
        // print("Sign In Failure: $state.signInFailure");
        print("Failed to Signed In");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(state.signInFailure!)),
        // );
      }
    }, child: BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.primaryBackground,
            appBar: buildAppBarLarge('Log In'),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/logo/CRM.png', // Your logo image path
                        width: 150.h,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 25.w, right: 25.w, top: 10.h),
                      margin: EdgeInsets.only(top: 25.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Center(
                          //   child: Image.asset(
                          //     'assets/logo/CRM.png', // Your logo image path
                          //     height: 100.h,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 15.h,
                          // ),
                          animatedTextScreen(),
                          reusableText("Email"),
                          SizedBox(
                            height: 5.h,
                          ),
                          formField(
                            fieldName: "email",
                            value: state.email,
                            controller: _signInController.emailController,
                            textType: "email",
                            hintText: "Enter your email address",
                            prefixIcon: const Icon(Icons.email),
                            inputType: TextInputType.emailAddress,
                            func: (value) {
                              context.read<SignInBloc>().add(EmailEvent(value));
                            },
                            formType: 'sign in',
                            context: context,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          reusableText("Password"),
                          formField(
                            fieldName: "password",
                            value: state.password,
                            controller: _signInController.passwordController,
                            textType: "password",
                            hintText: "Enter your password",
                            prefixIcon: const Icon(Icons.lock),
                            inputType: TextInputType.visiblePassword,
                            func: (value) {
                              context
                                  .read<SignInBloc>()
                                  .add(PasswordEvent(password: value));
                            },
                            formType: 'sign in',
                            context: context,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  alignment: Alignment.centerRight,
                                  iconSize: 13,
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.check_box_outline_blank)),
                              const Text(
                                "Remember Password",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.secondaryColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 175.w,
                              ),
                              forgotPassword(() {
                                Navigator.of(context)
                                    .pushNamed("/reset_password");
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),

                    state.isSignInLoading
                        ? const Center(child: CircularProgressIndicator())
                        : buildLogInAndRegButton("Log In", true, _handleSubmit),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Center(
                      child:
                          reusableText("Or use your google account to login"),
                    ),
                    state.isGoogleSignInLoading
                        ? const Center(child: CircularProgressIndicator())
                        : buildThirdPartyLogin(context, _handleGoogleSignIn),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: AppColors.secondaryColor),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("/sign_up");
                          },
                          child: const Text(
                            "sign up",
                            style: TextStyle(color: AppColors.accentColor),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    // buildLogInAndRegButton("Sign Up", "register", () {
                    //   Navigator.of(context).pushNamed("/sign_up");
                    // })
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ));
  }
}
