part of 'sign_up_bloc.dart';

enum ImagePickState {
  initialy,
  picked,
  failed,
}

class SignUpStates {
  final String email;
  final String password;
  final String repassword;
  final String name;

  final bool isSignUpLoading;
  final bool signUpSuccess;
  final String? signUpFailure;

  const SignUpStates({
    this.name = "",
    this.email = "",
    this.password = "",
    this.repassword = "",
    this.isSignUpLoading = false,
    this.signUpSuccess = false,
    this.signUpFailure = "",
  });
  SignUpStates.initial()
      : email = "",
        password = "",
        repassword = "",
        name = "",
        signUpSuccess = false,
        signUpFailure = null,
        isSignUpLoading = false;

  SignUpStates copyWith({
    UserEntity? user,
    String? name,
    String? email,
    String? password,
    String? repassword,
    bool? isValid,
    bool? isSignUpLoading,
    bool? signUpSuccess,
    String? signUpFailure,
    bool? obscurePassword,
    IconData? iconPassword,
    String? selected,
  }) {
    return SignUpStates(
      email: email ?? this.email,
      password: password ?? this.password,
      repassword: repassword ?? this.repassword,
      name: name ?? this.name,
      isSignUpLoading: isSignUpLoading ?? this.isSignUpLoading,
      signUpSuccess: signUpSuccess ?? this.signUpSuccess,
      signUpFailure: signUpFailure ?? this.signUpFailure,
    );
  }
}
