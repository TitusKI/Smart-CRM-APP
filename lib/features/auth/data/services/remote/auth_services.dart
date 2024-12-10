import 'package:dio/dio.dart';
import 'package:smart_crm_app/core/constants/constant.dart';
import 'package:smart_crm_app/features/auth/data/models/user_model.dart';
import 'package:smart_crm_app/injection_container.dart';

import '../../../domain/entities/login_entity.dart';
import '../../../domain/entities/signup_entity.dart';
import '../../../presentation/widgets/flutter_toast.dart';
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

  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstant.BASE_URL,
  ));
  AuthServicesImpl() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // final token = storageService.getToken();
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          storageService.clearTokens();
        }
        print(error.toString());
        return handler.next(error);
      },
    ));
  }
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
      print("token: ${data['token']}");
      await storageService.storeToken(
        token: data['token'],
        userId: data['data']['id'],
        email: data['data']['email'],
        name: data['data']['name'],
        role: data['data']['role'],
      );
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          toastInfo(msg: err.response!.data['message']);
          print("ERROR CATCHED: ${err.response!.data['message']}");
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
      await storageService.clearTokens();
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
      print(userInfo.toMap());
      final response = await _dio.post(
        "/users/signUp",
        data: userInfo.toMap(),
      );
      print(response.data);
      print("passed signup");
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
      print("Failed to sign up");
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _dio.delete("/users/deleteMe",
          options: Options(
            headers: {"Authorization": "Bearer ${storageService.getToken()}"},
          ),
          queryParameters: {
            "id": storageService.getUserId(),
          });
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
      print(data);
      getAllUsers();
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
      print("Trying to get user lists");

      final response = await _dio.get(
        '/users',
        options: Options(
            headers: {'Authorization': 'Bearer ${storageService.getToken()}'}),
      );
      final data = response.data['data']['users'];
      print(data);
      print((data as List)
          .map((userJson) => UserModel.fromMap(userJson).toEntity())
          .toList());

      print("Users fetched successfully");
      return (data)
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
