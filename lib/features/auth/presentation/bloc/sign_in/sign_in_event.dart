part of "sign_in_bloc.dart";

abstract class SignInEvent extends SharedEvent {
  const SignInEvent();
}

class SignInReset extends SignInEvent {}

class SignInSubmitEvent extends SignInEvent {
  final String email;
  final String password;
  const SignInSubmitEvent({required this.email, required this.password});
}

class GoogleSignInEvent extends SignInEvent {}

// class SignInLoadingEvent extends SignInEvent {}

// class SignInSuccessEvent extends SignInEvent {}

// class SignInFailureEvent extends SignInEvent {
//   final String error;
//   const SignInFailureEvent({required this.error});
// }
