import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:regexpattern/regexpattern.dart';

import '../../../features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';

class ResetPasswordController {
  // final TextEditingController newPasswordController = TextEditingController();
  // final TextEditingController confirmPasswordController =
  //     TextEditingController();
  final TextEditingController emailController = TextEditingController();
  // ResetPasswordController();
  // ResetSuccessful _resetSuccessful = const ResetSuccessful();
  String? handleEmailReset(String fieldName, String value) {
    switch (fieldName) {
      case 'email':
        if (value.isEmpty) {
          return "Email can't be empty";
        }
        if (!value.isEmail()) {
          return "Please Enter a Valid Email Address";
        }
        break;

      default:
        return null;
    }
    return null;
  }

  String? handlePasswordReset(
      BuildContext context, String fieldName, String value) {
    final ResetPasswordState state = context.read<ResetPasswordBloc>().state;
    switch (fieldName) {
      case 'password':
        if (value.isEmpty) {
          return "Password can't be empty ";
        }
        if (value.length < 8) {
          return "Password must be at least 8 character long";
        }
        break;
      case 'repassword':
        if (value.isEmpty) {
          return "Your password confirmation is wrong";
        }
        if (value != state.password) {
          return "The Password doesn't match the previous password";
        }
        break;

      default:
        return null;
    }

    return null;
  }
}
