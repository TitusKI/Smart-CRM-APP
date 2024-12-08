import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/features/auth/domain/entities/signup_entity.dart';
import 'package:smart_crm_app/features/auth/domain/usecases/signup.dart';

import '../../../../../core/resources/shared_event.dart';
import '../../../../../injection_container.dart';
part 'sign_up_event.dart';
part "sign_up_state.dart";

class SignUpBloc extends Bloc<SharedEvent, SignUpStates> {
  @override
  SignUpBloc() : super(SignUpStates.initial()) {
    on<EmailEvent>(_emailEvent);
    on<PasswordEvent>(_passwordEvent);
    on<NameEvent>(_nameEvent);
    on<SignUpReset>(
      (event, emit) => emit(SignUpStates.initial()),
    );
    // on<ProfileReset>((event, emit) => emit(state.copyWith()));
    on<SignUpSubmitEvent>(_signupSubmitEvent);
  }
  void _nameEvent(NameEvent event, Emitter<SignUpStates> emit) {
    emit(
      state.copyWith(name: event.name),
    );
  }

  Future<void> _signupSubmitEvent(
      SignUpSubmitEvent event, Emitter<SignUpStates> emit) async {
    emit(state.copyWith(isSignUpLoading: true));

    try {
      print("Signup init");
      await sl<SignupUsecase>().call(params: event.user);
      print("Signup done");
      // await sl<AuthRepository>()!.signUp(event.user);
      // On successful sign-up, update the state
      emit(state.copyWith(
        //  user: event.user, // Use the user returned from the repository
        isSignUpLoading: false,
        signUpSuccess: true, // Set to true on success
        signUpFailure: '', // Clear any previous failure message
      ));
    } catch (e) {
      emit(state.copyWith(
        isSignUpLoading: false,
        signUpSuccess: false,
        signUpFailure: e.toString(),
      ));
    }
  }

  void _emailEvent(EmailEvent event, Emitter<SignUpStates> emit) {
    emit(
      state.copyWith(email: event.email),
    );
  }

  void _passwordEvent(PasswordEvent event, Emitter<SignUpStates> emit) {
    print(event.password);
    print(event.repassword);

    emit(
      state.copyWith(password: event.password, repassword: event.repassword),
    );
  }
}
