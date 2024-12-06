import 'package:smart_crm_app/features/auth/domain/entities/signup_entity.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../injection_container.dart';
import '../repository/auth_repository.dart';

class CreateUserUsecase extends Usecase<void, UserEntity> {
  @override
  Future<void> call({UserEntity? params}) {
    return sl<AuthRepository>().createUser(params!);
  }
}
