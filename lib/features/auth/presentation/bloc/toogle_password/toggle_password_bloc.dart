import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'toggle_password_event.dart';
part 'toggle_password_state.dart';

class TogglePasswordBloc
    extends Bloc<TogglePasswordEvent, TogglePasswordState> {
  TogglePasswordBloc() : super(TogglePasswordInitial()) {
    on<TogglePasswordEvent>((event, emit) {
      emit(state.copyWith(
          obscurePassword: !state.obscurePassword,
          iconPassword: state.obscurePassword
              ? CupertinoIcons.eye_slash_fill
              : Icons.remove_red_eye_rounded));
    });
  }
}
