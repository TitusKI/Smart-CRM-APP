import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/routes/names.dart';
import '../../../../config/theme/colors.dart';
import '../../../../core/resources/shared_event.dart';
import '../../../../core/util/controller/reset_password_controller.dart';
import '../bloc/reset_password/reset_password_bloc.dart';
import '../widgets/common_widgets.dart';
import '../widgets/flutter_toast.dart';
import '../widgets/sign_up_widgets.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final _formKey = GlobalKey<FormState>();
  late ResetPasswordBloc _resetPasswordBloc;
  final ResetPasswordController _resetPasswordController =
      ResetPasswordController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resetPasswordBloc = BlocProvider.of<ResetPasswordBloc>(context);
  }

  @override
  void dispose() {
    _resetPasswordBloc.add(ResetEmail());

    super.dispose();
  }

  void _handleEmailSubmit() {
    if (_formKey.currentState!.validate()) {
      _resetPasswordBloc.add(SubmitResetCode(
        email: _resetPasswordController.emailController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state.isResetSuccess) {
          print("Successfully Reset  your password: with new reset Token");
          toastInfo(
              msg: "We have sent you a reset password link in your email");
          Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.LOGIN, (Route<dynamic> route) => false);
        }
        if (state.resetFailure != null) {
          // toastInfo(msg: "Failed To Rest");
          print("Reset Failure error is : ${state.resetFailure}");
        }
      },
      child: Scaffold(
        appBar: buildAppBarLarge("Sign In Help"),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 25.h,
                ),
                Center(
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryText,
                        fontSize: 25.sp),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Center(
                  child: reusableText(
                    "Enter your email address below\n and we'll send you a code to reset",
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                  builder: (context, state) {
                    return formField(
                      formType: "reset",
                      func: (value) {
                        context
                            .read<ResetPasswordBloc>()
                            .add(EmailEvent(value));
                      },
                      value: state.email,
                      controller: _resetPasswordController.emailController,
                      textType: "email",
                      inputType: TextInputType.visiblePassword,
                      hintText: "Enter your email",
                      prefixIcon: const Icon(Icons.email),
                      fieldName: "email",
                      context: context,
                    );
                  },
                ),
                BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                  builder: (context, state) {
                    return state.isResetLoading
                        ? const Center(child: CircularProgressIndicator())
                        : buildLogInAndRegButton(
                            "Get Code", true, _handleEmailSubmit);
                  },
                ),
                const SizedBox(
                  height: 14,
                ),
                const Center(
                  child: Text(
                    'Can\'t reset your password?',
                    style: TextStyle(
                        fontSize: 15,
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
