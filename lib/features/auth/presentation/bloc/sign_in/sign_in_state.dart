part of "sign_in_bloc.dart";

class SignInState {
  final String email;
  final String password;
  final bool obscurePassword;
  final IconData iconPassword;
  final bool isSignInLoading;
  final bool signInSuccess;
  final String? signInFailure;
  final bool isGoogleSignInLoading;
  final bool isGoogleSignInSuccess;
  final String? googleSignInFailure;

  const SignInState({
    this.isSignInLoading = false,
    this.signInSuccess = false,
    this.signInFailure = "",
    this.isGoogleSignInLoading = false,
    this.isGoogleSignInSuccess = false,
    this.googleSignInFailure = "",
    this.email = "",
    this.password = "",
    this.obscurePassword = true,
    this.iconPassword = Icons.remove_red_eye_rounded,
  });
  SignInState.initial()
      : email = "",
        password = "",
        obscurePassword = true,
        isSignInLoading = false,
        signInSuccess = false,
        signInFailure = null,
        isGoogleSignInLoading = false,
        isGoogleSignInSuccess = false,
        googleSignInFailure = null,
        iconPassword = Icons.remove_red_eye_rounded;
  SignInState copyWith(
      {String? email,
      String? password,
      bool? obscurePassword,
      IconData? iconPassword,
      bool? signInSuccess,
      bool? isSignInLoading,
      String? signInFailure,
      bool? isGoogleSignInLoading,
      bool? isGoogleSignInSuccess,
      String? googleSignInFailure}) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      iconPassword: iconPassword ?? this.iconPassword,
      isSignInLoading: isSignInLoading ?? this.isSignInLoading,
      signInFailure: signInFailure ?? this.signInFailure,
      signInSuccess: signInSuccess ?? this.signInSuccess,
      isGoogleSignInLoading:
          isGoogleSignInLoading ?? this.isGoogleSignInLoading,
      googleSignInFailure: googleSignInFailure ?? this.googleSignInFailure,
      isGoogleSignInSuccess:
          isGoogleSignInSuccess ?? this.isGoogleSignInSuccess,
    );
  }
}
