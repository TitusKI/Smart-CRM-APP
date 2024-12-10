import 'package:dio/dio.dart';

import '../../../../core/constants/constant.dart';
import '../../../../injection_container.dart';
import '../../../auth/data/services/local/storage_services.dart';
import '../../domain/entities/notification_entity.dart';
import '../models/notification_model.dart';

abstract class NotificationServices {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markNotificationAsRead(String id);
}

class NotificationServicesImpl implements NotificationServices {
  final storageService = sl<StorageServices>();

  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstant.BASE_URL, headers: {
    'Content-Type': 'application/json',
  }));
  NotificationServicesImpl() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        const pathsWithHeaders = [
          "/notifications",
          "/notifications/:id/read",
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
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      final userId = await storageService.getUserId();
      if (userId == null) {
        throw Exception('User is not logged in');
      }
      final response = await _dio.get(
        '/notifications',
        queryParameters: {'user_id': userId},
      );
      print(response.data);
      if (response.statusCode == 200) {
        final data = response.data['data']['notifications'];
        print(data);
        return (data as List)
            .map((notificationJson) =>
                NotificationModel.fromJson(notificationJson).toEntity())
            .toList();
      } else {
        throw Exception('Failed to load notifications');
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
    return [];
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    try {
      print("Id in markNotificationAsRead: $id");
      final response = await _dio.post('/notifications/$id/read',
          options: Options(headers: {
            'Authorization': 'Bearer ${storageService.getToken()}'
          }));
      print(response.data);
      if (response.statusCode == 200) {
        print("Notification marked as read");
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
