class UserEntity {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  final String? profileImage;
  final String? role;

  UserEntity({
    required this.confirmPassword,
    this.profileImage,
    this.role,
    required this.email,
    required this.password,
    required this.name,
  });
}
