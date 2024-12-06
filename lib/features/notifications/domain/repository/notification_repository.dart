import 'package:smart_crm_app/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markNotificationAsRead(String id);
}
