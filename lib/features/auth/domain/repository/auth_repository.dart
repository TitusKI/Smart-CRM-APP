import 'package:smart_crm_app/features/auth/domain/entities/login_entity.dart';
import 'package:smart_crm_app/features/auth/domain/entities/signup_entity.dart';

abstract class AuthRepository {
  Future<void> login(LoginEntity entity);
  Future<void> signup(UserEntity signupEnitity);
  Future<void> logout();
  Future<void> deleteMyAccount();
// admin functionality
  Future<List<UserEntity>> getAllUsers();
  Future<UserEntity> getUserById(String id);
  Future<void> createUser(UserEntity user);
  Future<void> deleteUser(String id);
}
