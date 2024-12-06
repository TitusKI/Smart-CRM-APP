import 'package:smart_crm_app/core/usecase/usecase.dart';

import '../../../../injection_container.dart';
import '../entities/login_entity.dart';
import '../repository/auth_repository.dart';

class LoginUsecase extends Usecase<void, LoginEntity> {
  @override
  Future<void> call({LoginEntity? params}) async {
    return await sl<AuthRepository>().login(params!);
  }
}
