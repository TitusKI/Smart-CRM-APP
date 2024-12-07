import 'package:smart_crm_app/features/auth/domain/entities/signup_entity.dart';

class UserModel {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  final String? profileImage;
  final String? role;
  const UserModel({
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
      'passwordConfirmation': confirmPassword,
      'name': name,
      'profileImage': profileImage ?? "",
      'role': role ?? "user",
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      password: map['password'],
      confirmPassword: map['confirmPassword'],
      name: map['name'],
      profileImage: map['profileImage'],
      role: map['role'],
    );
  }
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      name: entity.name,
      profileImage: entity.profileImage,
      role: entity.role,
    );
  }
  UserEntity toEntity() {
    return UserEntity(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      name: name,
      profileImage: profileImage,
      role: role,
    );
  }
}
