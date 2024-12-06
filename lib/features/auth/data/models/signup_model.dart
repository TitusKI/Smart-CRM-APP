import 'package:smart_crm_app/features/auth/domain/entities/signup_entity.dart';

class SignupModel {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  final String? profileImage;
  final String? role;
  const SignupModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.name,
    this.profileImage,
    this.role,
  });
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'name': name,
      'profileImage': profileImage,
      'role': role,
    };
  }

  factory SignupModel.fromMap(Map<String, dynamic> map) {
    return SignupModel(
      email: map['email'],
      password: map['password'],
      confirmPassword: map['confirmPassword'],
      name: map['name'],
      profileImage: map['profileImage'],
      role: map['role'],
    );
  }
  factory SignupModel.fromEntity(SignupEntity entity) {
    return SignupModel(
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      name: entity.name,
      profileImage: entity.profileImage,
      role: entity.role,
    );
  }
}
