import 'package:dio/dio.dart';
import 'package:smart_crm_app/core/constants/constant.dart';
import 'package:smart_crm_app/features/auth/data/models/user_model.dart';
import 'package:smart_crm_app/injection_container.dart';

import '../../../domain/entities/login_entity.dart';
import '../../../domain/entities/signup_entity.dart';
import '../local/storage_services.dart';

abstract class AuthServices {
  Future<void> login(LoginEntity entity);
  Future<void> signup(UserEntity signupEnitity);
  Future<void> logout();
  Future<void> deleteAccount();
  Future<void> createUser(UserEntity user);
  Future<void> deleteUser(String id);
  Future<List<UserEntity>> getAllUsers();
  Future<UserEntity> getUserById(String id);
}

class AuthServicesImpl implements AuthServices {
  final storageService = sl<StorageServices>();

  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstant.BASE_URL, headers: {
    'Content-Type': 'application/json',
  }));

  @override
  Future<void> login(LoginEntity entity) async {
    try {
      final response = await _dio.post("/users/login", data: {
        "email": entity.email,
        "password": entity.password,
      });
      final data = response.data;
      if (data == null || data['token'] == null) {
        throw Exception("Login failed: No access token received");
      }

      await storageService.storeToken(
          token: data['token'],
          userId: data['_id']['\$oid'],
          email: data['email']);
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
  Future<void> logout() async {
    final token = storageService.getToken();
    try {
      await _dio.post("/users/logout",
          options: Options(headers: {'Authorization': "Bearer $token"}));
      storageService.clearTokens();
      print("Successfuly signed out");
    } catch (e) {
      print("Error while signing out: $e");
    }
  }

  @override
  Future<void> signup(UserEntity entity) async {
    await storageService.clearTokens();
    try {
      final UserModel userInfo = UserModel.fromEntity(entity);
      final response = await _dio.post("/users/signUp", data: userInfo.toMap());
      final data = response.data;
      if (data == null || data['token'] == null) {
        throw Exception("Sign up  failed: No access token received");
      }
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
  Future<void> deleteAccount() async {
    try {
      await _dio.delete("/users/deleteMe",
          options: Options(headers: {
            "Authorization": "Bearer ${storageService.getToken()}"
          }));
      storageService.clearTokens();
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
  Future<void> createUser(UserEntity user) async {
    try {
      final UserModel userInfo = UserModel.fromEntity(user);
      final response = await _dio.post("/users/",
          data: userInfo.toMap(),
          options: Options(headers: {
            "Authorization": "Bearer ${storageService.getToken()}"
          }));
      final data = response.data;
      if (data == null) {
        throw Exception(
            "User registerd failed  failed: No access token received");
      }
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
  Future<void> deleteUser(String id) async {
    try {
      await _dio.delete("/users/$id",
          options: Options(headers: {
            "Authorization": "Bearer ${storageService.getToken()}"
          }));
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
  Future<List<UserEntity>> getAllUsers() async {
    try {
      final response = await _dio.get(
        '/users',
        options: Options(
            headers: {'Authorization': 'Bearer ${storageService.getToken()}'}),
      );
      final data = response.data['data'];
      return (data as List)
          .map((userJson) => UserModel.fromMap(userJson).toEntity())
          .toList();
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
  Future<UserEntity> getUserById(String id) async {
    try {
      final response = await _dio.get(
        '/users/$id',
        options: Options(
            headers: {'Authorization': 'Bearer ${storageService.getToken()}'}),
      );
      final data = response.data['data'];
      return UserModel.fromMap(data).toEntity();
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
      }
    }
    return const UserModel(
      email: '',
      password: '',
      confirmPassword: '',
      name: '',
    ).toEntity();
  }
}
