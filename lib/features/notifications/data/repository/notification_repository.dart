import 'package:smart_crm_app/features/notifications/domain/entities/notification_entity.dart';

import '../../domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<List<NotificationEntity>> getNotifications() {
    // TODO: implement getNotifications
    throw UnimplementedError();
  }

  @override
  Future<void> markNotificationAsRead(String id) {
    // TODO: implement markNotificationAsRead
    throw UnimplementedError();
  }
}
