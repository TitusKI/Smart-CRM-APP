part of 'toggle_password_bloc.dart';

sealed class TogglePasswordEvent extends Equatable {
  const TogglePasswordEvent();

  @override
  List<Object> get props => [];
}

class TogglePasswordVisibility extends TogglePasswordEvent {}
