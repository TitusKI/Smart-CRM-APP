import 'package:smart_crm_app/core/usecase/usecase.dart';
import 'package:smart_crm_app/features/contacts/domain/repository/contact_repository.dart';
import 'package:smart_crm_app/injection_container.dart';

class DeleteContactUsecase extends Usecase<void, String> {
  @override
  Future<void> call({String? params}) async {
    return await sl<ContactRepository>().deleteContact(params!);
  }
}
