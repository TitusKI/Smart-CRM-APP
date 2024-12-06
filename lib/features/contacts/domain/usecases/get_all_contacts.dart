import 'package:smart_crm_app/core/usecase/usecase.dart';
import 'package:smart_crm_app/features/contacts/domain/repository/contact_repository.dart';
import 'package:smart_crm_app/injection_container.dart';

import '../entities/contact_entity.dart';

class GetAllContactsUsecase extends Usecase<List<ContactEntity>, void> {
  @override
  Future<List<ContactEntity>> call({void params}) async {
    return await sl<ContactRepository>().getAllContacts();
  }
}
