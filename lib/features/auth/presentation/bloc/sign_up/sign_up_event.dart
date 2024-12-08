part of "sign_up_bloc.dart";

abstract class SignUpEvents extends SharedEvent {
  const SignUpEvents();
}

class SignUpSubmitEvent extends SignUpEvents {
  final UserEntity user;
  const SignUpSubmitEvent(this.user);
}

class SignUpReset extends SignUpEvents {}
