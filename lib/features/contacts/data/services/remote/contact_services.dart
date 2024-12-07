import 'package:dio/dio.dart';
import 'package:smart_crm_app/features/contacts/data/models/contact_model.dart';

import '../../../../../core/constants/constant.dart';
import '../../../../../injection_container.dart';
import '../../../../auth/data/services/local/storage_services.dart';
import '../../../domain/entities/contact_entity.dart';

abstract class ContactServices {
  Future<void> addContact(ContactEntity contact);
  Future<void> deleteContact(String id);
  Future<void> updateContact(ContactEntity contact);
  Future<List<ContactEntity>> getAllContacts();
  Future<ContactEntity> getContactById(String id);
}

class ContactServicesImpl implements ContactServices {
  final storageService = sl<StorageServices>();

  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstant.BASE_URL, headers: {
    'Content-Type': 'application/json',
  }));
  ContactServicesImpl() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        const pathsWithHeaders = [
          "/contacts",
          "/contacts/:id",
        ];
        if (pathsWithHeaders.contains(options.path)) {
          if (pathsWithHeaders.contains(options.path)) {
            print("Path with Header for access Token");
            final token = storageService.getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              print("Access Token with The same path headers");
              print(token);
            }
          }
        }
        return handler.next(options);
      },
    ));
  }

  @override
  Future<void> addContact(ContactEntity contact) async {
    final contactInfo = ContactModel.fromEntity(contact);
    try {
      final response = await _dio.post("/contacts", data: contactInfo.toJson());
      final data = response.data;
      if (data == null || data['token'] == null) {
        throw Exception("Adding contact failed: No access token received");
      }
      print("Contact added successfully");
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
        throw Exception("Unexpected error :$err");
      }
    }
  }

  @override
  Future<void> deleteContact(String id) async {
    try {
      final response = await _dio.delete("/contacts/$id");
      final data = response.data;
      if (data == null || data['token'] == null) {
        throw Exception("Deleting contact failed: No access token received");
      }
      print("Contact deleted successfully");
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
      }
    }
  }

  @override
  Future<List<ContactEntity>> getAllContacts() async {
    try {
      final response = await _dio.get("/contacts");
      final data = response.data;
      if (data == null || data['token'] == null) {
        throw Exception("Getting contacts failed: No access token received");
      }
      print("Contacts fetched successfully");
      return (data).map((e) => ContactModel.fromJson(e).toEntity()).toList()
          as List<ContactEntity>;
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
      }
    }
    return [];
  }

  @override
  Future<ContactEntity> getContactById(String id) async {
    try {
      final response = await _dio.get("/contacts/$id");
      final data = response.data;
      if (data == null || data['token'] == null) {
        throw Exception("Getting contact failed: No access token received");
      }
      print("Contact fetched successfully");
      return ContactModel.fromJson(data).toEntity();
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
      }
    }
    return ContactModel.fromJson({}).toEntity();
  }

  @override
  Future<void> updateContact(ContactEntity contact) async {
    try {
      await _dio.patch("/contacts/${contact.id}",
          data: ContactModel.fromEntity(contact).toJson());
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
      }
    }
  }
}
