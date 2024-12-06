import 'package:smart_crm_app/core/usecase/usecase.dart';
import 'package:smart_crm_app/features/contacts/domain/repository/contact_repository.dart';
import 'package:smart_crm_app/injection_container.dart';

import '../entities/contact_entity.dart';

class GetContactByIdUsecase extends Usecase<ContactEntity, String> {
  @override
  Future<ContactEntity> call({String? params}) async {
    return await sl<ContactRepository>().getContactById(params!);
  }
}
