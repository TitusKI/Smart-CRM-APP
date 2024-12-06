import '../entities/contact_entity.dart';

abstract class ContactRepository {
  Future<void> addContact(ContactEntity contact);
  Future<void> deleteContact(String id);
  Future<void> updateContact(ContactEntity contact);
  Future<List<ContactEntity>> getAllContacts();
  Future<ContactEntity> getContactById(String id);
}
