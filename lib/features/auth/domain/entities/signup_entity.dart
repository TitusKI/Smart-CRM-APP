class UserEntity {
  final String email;
  final String? password;
  final String? confirmPassword;
  final String name;
  final String? profileImage;
  final String? role;
  final String? id;

  UserEntity({
    this.confirmPassword,
    this.profileImage,
    this.id,
    this.role,
    required this.email,
    this.password,
    required this.name,
  });
}
