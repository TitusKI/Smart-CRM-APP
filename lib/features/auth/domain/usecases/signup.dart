import 'package:smart_crm_app/core/usecase/usecase.dart';
import 'package:smart_crm_app/features/auth/domain/repository/auth_repository.dart';

import '../../../../injection_container.dart';
import '../entities/signup_entity.dart';

class SignupUsecase extends Usecase<void, SignupEntity> {
  @override
  Future<void> call({SignupEntity? params}) async {
    return await sl<AuthRepository>().signup(params!);
  }
}
