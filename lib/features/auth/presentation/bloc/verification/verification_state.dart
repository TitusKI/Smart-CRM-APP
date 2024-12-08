part of 'verification_bloc.dart';

sealed class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object> get props => [];
}

final class VerificationInitial extends VerificationState {}

class VerificationCodeInvalid extends VerificationState {
  final String code;

  const VerificationCodeInvalid(this.code);

  @override
  List<Object> get props => [code];
}

class VerificationCodeValid extends VerificationState {
  final String code;

  const VerificationCodeValid(this.code);

  @override
  List<Object> get props => [code];
}

class VerificationLoading extends VerificationState {}

class VerificationSuccess extends VerificationState {}

class VerificationFailure extends VerificationState {
  final String error;

  const VerificationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class VerificationSubmitted extends VerificationState {
  final String code;
  final String email;
  const VerificationSubmitted({required this.code, required this.email});
  @override
  List<Object> get props => [code];
}

class VerificationResetSubmitted extends VerificationState {
  final String email;
  const VerificationResetSubmitted({required this.email});
}

class VerificationReset extends VerificationState {}

class VerificationCodeResent extends VerificationState {}
