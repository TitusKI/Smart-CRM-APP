import 'package:smart_crm_app/core/usecase/usecase.dart';
import 'package:smart_crm_app/features/auth/domain/repository/auth_repository.dart';
import 'package:smart_crm_app/injection_container.dart';

class DeleteAccountUsecase extends Usecase<void, void> {
  @override
  Future<void> call({void params}) async {
    return await sl<AuthRepository>().deleteMyAccount();
  }
}
