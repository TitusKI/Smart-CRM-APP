import 'package:flutter/material.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/features/auth/domain/entities/signup_entity.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/resources/shared_event.dart';
import '../../../../core/util/controller/sign_up_controller.dart';
import '../bloc/sign_up/sign_up_bloc.dart';
import '../widgets/common_widgets.dart';
import '../widgets/sign_up_widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final SignUpController _signUpController = SignUpController();
  String formType = "sign up";

  final _formKey = GlobalKey<FormState>();
  late SignUpBloc _signUpBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // UserRepository repository = UserRepository();
    // _signUpBloc = SignUpBloc(repository);
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);
  }

  @override
  void dispose() {
    _signUpBloc.add(SignUpReset());
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final user = UserEntity(
        email: _signUpController.emailController.text,
        password: _signUpController.passwordController.text,
        confirmPassword: _signUpController.confirmPasswordController.text,
        name: _signUpController.nameController.text,
      );
      _signUpBloc.add(SignUpSubmitEvent(user));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpStates>(
      listener: (context, state) {
        if (state.signUpSuccess) {
          final email = state.email;
          // Navigate to the verification screen
          print("Successfully Signed Up: $email");
          Navigator.of(context)
              .pushNamed("/sign_up_verification", arguments: email);
        }

        if (state.signUpFailure != null) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.signUpFailure!)),
          );
        }
      },
      child: BlocBuilder<SignUpBloc, SignUpStates>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Container(
              color: AppColors.primaryBackground,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: AppColors.primaryBackground,
                  appBar: buildAppBarLarge("Sign Up"),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                            child: reusableText(
                                "Enter your details below and free sign Up")),
                        Container(
                          padding: EdgeInsets.only(left: 25.w, right: 25.w),
                          margin: EdgeInsets.only(top: 50.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              reusableText("Name"),
                              formField(
                                  fieldName: "name",
                                  value: state.name,
                                  controller: _signUpController.nameController,
                                  textType: "email",
                                  hintText: "Enter your email address",
                                  prefixIcon: const Icon(Icons.person),
                                  inputType: TextInputType.name,
                                  func: (value) {
                                    context
                                        .read<SignUpBloc>()
                                        .add(NameEvent(value));
                                  },
                                  formType: formType,
                                  context: context),
                              SizedBox(
                                height: 20.h,
                              ),
                              reusableText("Email"),
                              formField(
                                  fieldName: "email",
                                  value: state.email,
                                  controller: _signUpController.emailController,
                                  textType: "email",
                                  hintText: "Enter your email address",
                                  prefixIcon: const Icon(Icons.email),
                                  inputType: TextInputType.emailAddress,
                                  func: (value) {
                                    context
                                        .read<SignUpBloc>()
                                        .add(EmailEvent(value));
                                  },
                                  formType: formType,
                                  context: context),
                              SizedBox(
                                height: 20.h,
                              ),
                              reusableText("Password"),
                              formField(
                                formType: formType,
                                fieldName: "password",
                                value: state.password,
                                controller:
                                    _signUpController.passwordController,
                                textType: "password",
                                hintText: "Enter your password",
                                prefixIcon: const Icon(Icons.lock),
                                inputType: TextInputType.visiblePassword,
                                func: (value) {
                                  context
                                      .read<SignUpBloc>()
                                      .add(PasswordEvent(password: value));
                                },
                                context: context,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              reusableText("Confirm Password"),
                              formField(
                                formType: formType,
                                fieldName: "repassword",
                                value: state.repassword,
                                controller:
                                    _signUpController.confirmPasswordController,
                                textType: "password",
                                hintText: "Re-enter your password to confirm",
                                prefixIcon: const Icon(Icons.lock),
                                inputType: TextInputType.visiblePassword,
                                func: (value) {
                                  context
                                      .read<SignUpBloc>()
                                      .add(PasswordEvent(repassword: value));
                                },
                                context: context,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 25.w),
                          child: reusableText(
                              "By creating an account you have agree with our terms and conditions"),
                        ),
                        state.isSignUpLoading
                            ? const Center(child: CircularProgressIndicator())
                            : buildLogInAndRegButton(
                                "Sign Up", true, _handleSubmit)
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
