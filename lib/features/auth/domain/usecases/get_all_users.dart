import 'package:smart_crm_app/features/auth/domain/entities/signup_entity.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../injection_container.dart';
import '../repository/auth_repository.dart';

class GetAllUsersUsecase extends Usecase<List<UserEntity>, void> {
  @override
  Future<List<UserEntity>> call({void params}) {
    return sl<AuthRepository>().getAllUsers();
  }
}
