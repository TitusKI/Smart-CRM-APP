import 'package:dio/dio.dart';
import 'package:smart_crm_app/core/constants/constant.dart';
import 'package:smart_crm_app/features/auth/data/models/signup_model.dart';
import 'package:smart_crm_app/injection_container.dart';

import '../../../domain/entities/login_entity.dart';
import '../../../domain/entities/signup_entity.dart';
import '../local/storage_services.dart';

abstract class AuthServices {
  Future<void> login(LoginEntity entity);
  Future<void> signup(SignupEntity signupEnitity);
  Future<void> logout();
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
      await storageService.storeToken(token: data['token']);
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
  Future<void> signup(SignupEntity entity) async {
    await storageService.clearTokens();
    try {
      final SignupModel userInfo = SignupModel.fromEntity(entity);
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
}
