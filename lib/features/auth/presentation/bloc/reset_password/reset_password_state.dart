part of 'reset_password_bloc.dart';

class ResetPasswordState {
  final String email;
  final String password;
  final String repassword;
  final bool isResetLoading;
  final bool isResetSuccess;
  final String? resetFailure;
  const ResetPasswordState({
    this.isResetLoading = false,
    this.isResetSuccess = false,
    this.resetFailure = "",
    this.email = "",
    this.password = "",
    this.repassword = "",
  });
  ResetPasswordState copyWith({
    String? email,
    String? password,
    String? repassword,
    bool? isResetLoading,
    bool? isResetSuccess,
    String? resetFailure,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      password: password ?? this.password,
      repassword: repassword ?? this.repassword,
      isResetLoading: isResetLoading ?? this.isResetLoading,
      isResetSuccess: isResetSuccess ?? this.isResetSuccess,
      resetFailure: resetFailure ?? this.resetFailure,
    );
  }
}

class ResetToInitial extends ResetPasswordState {}
