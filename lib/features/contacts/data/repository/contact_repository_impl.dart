import 'package:smart_crm_app/features/contacts/data/services/remote/contact_services.dart';
import 'package:smart_crm_app/features/contacts/domain/entities/contact_entity.dart';
import 'package:smart_crm_app/features/contacts/domain/repository/contact_repository.dart';
import 'package:smart_crm_app/injection_container.dart';

class ContactRepositoryImpl implements ContactRepository {
  @override
  Future<void> addContact(ContactEntity contact) {
    return sl<ContactServices>().addContact(contact);
  }

  @override
  Future<void> deleteContact(String id) {
    return sl<ContactServices>().deleteContact(id);
  }

  @override
  Future<List<ContactEntity>> getAllContacts() {
    return sl<ContactServices>().getAllContacts();
  }

  @override
  Future<ContactEntity> getContactById(String id) {
    return sl<ContactServices>().getContactById(id);
  }

  @override
  Future<void> updateContact(ContactEntity contact) {
    return sl<ContactServices>().updateContact(contact);
  }
}
