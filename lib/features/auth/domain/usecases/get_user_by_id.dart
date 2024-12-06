import 'package:smart_crm_app/features/auth/domain/entities/signup_entity.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../injection_container.dart';
import '../repository/auth_repository.dart';

class GetUserByIdUsecase extends Usecase<UserEntity, String> {
  @override
  Future<UserEntity> call({String? params}) {
    return sl<AuthRepository>().getUserById(params!);
  }
}
