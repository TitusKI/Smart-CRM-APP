import 'package:smart_crm_app/features/auth/data/services/remote/auth_services.dart';
import 'package:smart_crm_app/features/auth/domain/entities/login_entity.dart';
import 'package:smart_crm_app/features/auth/domain/entities/signup_entity.dart';
import 'package:smart_crm_app/features/auth/domain/repository/auth_repository.dart';
import 'package:smart_crm_app/injection_container.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<void> login(LoginEntity entity) async {
    print("repository login email is ${entity.email}");
    await sl<AuthServices>().login(entity);
  }

  @override
  Future<void> logout() async {
    await sl<AuthServices>().logout();
  }

  @override
  Future<void> signup(SignupEntity entity) {
    print("Repository sign up email is ${entity.email}");
    return sl<AuthServices>().signup(entity);
  }
}
