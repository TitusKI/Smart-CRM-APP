import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/core/constants/exports.dart';
import 'package:smart_crm_app/features/contacts/domain/usecases/get_all_contacts.dart';
import 'package:smart_crm_app/features/contacts/domain/usecases/update_contact.dart';

import '../../../../core/resources/generic_state.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/usecases/add_contact.dart';

class ContactCubit extends Cubit<GenericState> {
  ContactCubit() : super(const GenericState(isLoading: true));

  // Fetch all contacts
  Future<void> fetchContacts() async {
    emit(state.copyWith(isLoading: true));
    try {
      final contacts = await sl<GetAllContactsUsecase>().call();
      emit(GenericState(data: contacts, isSuccess: true));
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  // Fetch contact by id
  Future<void> fetchContactsId(String id) async {
    emit(state.copyWith(isLoading: true));
    try {
      final contacts = await sl<GetContactByIdUsecase>().call(params: id);
      emit(GenericState(data: contacts, isSuccess: true));
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  // Add a contact
  Future<void> addContact(ContactEntity contact) async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl<AddContactUsecase>().call(params: contact);
      fetchContacts();
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  // Delete a contact
  Future<void> deleteContact(String id) async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl<DeleteContactUsecase>().call(params: id);
      fetchContacts(); // Refresh contacts after deletion
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  // Update a contact
  Future<void> updateContact(ContactEntity contact) async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl<UpdateContactUsecase>().call(params: contact);
      fetchContacts(); // Refresh contacts after updating
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }
}
