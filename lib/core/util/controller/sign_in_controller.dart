import 'package:flutter/material.dart';

import 'package:regexpattern/regexpattern.dart';

class SignInController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? handleSignIn(String fieldName, String value) {
    print("email: ${emailController.text}");
    switch (fieldName) {
      case 'email':
        if (value.isEmpty) {
          return "Email can't be empty";
        }
        if (!value.isEmail()) {
          return "Please Enter a Valid Email Address";
        }
        break;
      case 'password':
        if (value.isEmpty) {
          return "Password can't be empty ";
        }
        break;

      default:
        return null;
    }

    return null;
  }
}
