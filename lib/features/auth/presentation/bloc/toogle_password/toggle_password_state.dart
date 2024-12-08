part of 'toggle_password_bloc.dart';

class TogglePasswordState extends Equatable {
  final IconData iconPassword;
  final bool obscurePassword;

  const TogglePasswordState({
    this.iconPassword = Icons.remove_red_eye_rounded,
    this.obscurePassword = true,
  });
  TogglePasswordState copyWith({
    IconData? iconPassword,
    bool? obscurePassword,
  }) {
    return TogglePasswordState(
      iconPassword: iconPassword ?? this.iconPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object> get props => [iconPassword, obscurePassword];
}

final class TogglePasswordInitial extends TogglePasswordState {}
