part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends SharedEvent {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class SubmitResetCode extends ResetPasswordEvent {
  final String? email;
  const SubmitResetCode({this.email});
}

class SubmitNewPassword extends ResetPasswordEvent {
  final String? newPassword;
  final String? passwordConfirm;
  const SubmitNewPassword({this.newPassword, this.passwordConfirm});
}

class ResetEmail extends ResetPasswordEvent {}
