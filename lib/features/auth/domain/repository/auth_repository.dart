import 'package:smart_crm_app/features/auth/domain/entities/login_entity.dart';
import 'package:smart_crm_app/features/auth/domain/entities/signup_entity.dart';

abstract class AuthRepository {
  Future<void> login(LoginEntity entity);
  Future<void> signup(SignupEntity signupEnitity);
  Future<void> logout();
}
