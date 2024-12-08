part of 'verification_bloc.dart';

sealed class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object> get props => [];
}

class CodeChanged extends VerificationEvent {
  final String code;
  const CodeChanged(this.code);
  @override
  List<Object> get props => [code];
}

class SubmitCode extends VerificationEvent {
  final int? code;
  final String? email;
  const SubmitCode({this.code, this.email});
  @override
  List<Object> get props => [code!, email!];
}

class ResendCode extends VerificationEvent {
  final String email;
  const ResendCode(this.email);
  @override
  List<Object> get props => [email];
}

class ResetCode extends VerificationEvent {}
