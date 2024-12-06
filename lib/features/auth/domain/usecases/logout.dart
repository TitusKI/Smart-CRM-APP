import 'package:smart_crm_app/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../injection_container.dart';

class LogoutUsecase extends Usecase<void, void> {
  @override
  Future<void> call({void params}) {
    return sl<AuthRepository>().logout();
  }
}
