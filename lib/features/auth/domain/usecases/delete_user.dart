import '../../../../core/usecase/usecase.dart';
import '../../../../injection_container.dart';
import '../repository/auth_repository.dart';

class DeleteUserUsecase extends Usecase<void, String> {
  @override
  Future<void> call({String? params}) {
    return sl<AuthRepository>().deleteUser(params!);
  }
}
