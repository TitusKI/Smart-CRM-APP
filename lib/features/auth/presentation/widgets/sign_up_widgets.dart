// import 'package:afalagi/bloc/sign_in/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/util/controller/reset_password_controller.dart';
import '../../../../core/util/controller/sign_in_controller.dart';
import '../../../../core/util/controller/sign_up_controller.dart';
import '../bloc/toogle_password/toggle_password_bloc.dart';
import 'build_textfield.dart';

Widget formField({
  required String formType,
  required BuildContext context,
  String? fieldName,
  String? value,
  TextEditingController? controller,
  String? textType,
  String? hintText,
  Icon? prefixIcon,
  TextInputType? inputType,
  void Function(String value)? func,
  List<TextInputFormatter>? inputFormatters,
}) {
  IconButton? suffixIcon;
  bool? obscureText;
  if (fieldName == "password" || fieldName == "repassword") {
    suffixIcon = IconButton(
      onPressed: () {
        context.read<TogglePasswordBloc>().add(TogglePasswordVisibility());
      },
      icon: Icon(
          context.select((TogglePasswordBloc bloc) => bloc.state.iconPassword)),
      color: AppColors.accentColor,
    );
    obscureText =
        context.select((TogglePasswordBloc bloc) => bloc.state.obscurePassword);
  } else {
    suffixIcon = null;
  }
  return MyTextField(
    prefixIcon: prefixIcon,
    controller: controller!,
    validator: (validate) =>
        _validator(context, formType, value, fieldName, textType),
    hintText: hintText!,
    obscureText: fieldName == "password" || fieldName == "repassword"
        ? obscureText!
        : false,
    suffixIcon: suffixIcon,
    keyboardType: inputType!,
    onChanged: (value) => func!(value),
  );
}

// ignore: body_might_complete_normally_nullable
String? _validator(BuildContext context, String? formType, String? value,
    String? fieldName, String? textType) {
  switch (formType) {
    case "sign in":
      return SignInController().handleSignIn(fieldName!, value!);
    case "sign up":
      return SignUpController().handleEmailSignUp(context, fieldName!, value!);

    case "reset":
      if (fieldName == "password" || fieldName == "repassword") {
        return ResetPasswordController()
            .handlePasswordReset(context, fieldName!, value!);
      } else {
        return ResetPasswordController().handleEmailReset(fieldName!, value!);
      }
    default:
      return null;
  }
}
