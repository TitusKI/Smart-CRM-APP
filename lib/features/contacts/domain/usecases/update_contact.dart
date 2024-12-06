import 'package:smart_crm_app/core/usecase/usecase.dart';
import 'package:smart_crm_app/features/contacts/domain/repository/contact_repository.dart';
import 'package:smart_crm_app/injection_container.dart';

import '../entities/contact_entity.dart';

class UpdateContactUsecase extends Usecase<void, ContactEntity> {
  @override
  Future<void> call({ContactEntity? params}) async {
    return await sl<ContactRepository>().updateContact(params!);
  }
}
