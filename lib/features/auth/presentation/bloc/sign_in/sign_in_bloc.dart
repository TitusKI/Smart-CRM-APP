import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_crm_app/features/auth/domain/entities/login_entity.dart';
import 'package:smart_crm_app/features/auth/domain/usecases/login.dart';

import '../../../../../core/resources/shared_event.dart';
import '../../../../../injection_container.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SharedEvent, SignInState> {
  SignInBloc() : super(const SignInState()) {
    on<EmailEvent>(_emailEvent);
    on<PasswordEvent>(_passwordEvent);
    on<SignInReset>(_resetToInitial);
    on<SignInSubmitEvent>(_signInSubmitEvent);
    // on<TogglePasswordVisibility>(togglePasswordVisibility);
  }
  Future<void> _signInSubmitEvent(
      SignInSubmitEvent event, Emitter<SignInState> emit) async {
    emit(state.copyWith(isSignInLoading: true));
    try {
      await sl<LoginUsecase>().call(
          params: LoginEntity(email: event.email, password: event.password));

      // await sl<AuthRepository>().signin(event.email, event.password);
      emit(state.copyWith(
        isSignInLoading: false,
        signInSuccess: true,
        signInFailure: "",
      ));
    } catch (e) {
      emit(state.copyWith(
          isSignInLoading: false,
          signInFailure: e.toString(),
          signInSuccess: false));
    }
  }

  void _resetToInitial(SignInReset event, Emitter<SignInState> emit) {
    emit(SignInState.initial());
  }

  void _emailEvent(EmailEvent event, Emitter<SignInState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _passwordEvent(PasswordEvent event, Emitter<SignInState> emit) {
    // print("My Password is:${event.password}");
    emit(state.copyWith(password: event.password));
  }

  // void togglePasswordVisibility(
  //     TogglePasswordVisibility event, Emitter<SignInState> emit) {
  //   emit(state.copyWith(
  //       obscurePassword: !state.obscurePassword,
  //       iconPassword: state.obscurePassword
  //           ? CupertinoIcons.eye_slash_fill
  //           : Icons.remove_red_eye_rounded));
  // }
}
