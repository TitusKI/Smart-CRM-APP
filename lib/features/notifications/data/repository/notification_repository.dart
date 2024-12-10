import 'package:smart_crm_app/features/notifications/domain/entities/notification_entity.dart';

import '../../../../injection_container.dart';
import '../../domain/repository/notification_repository.dart';
import '../services/notification_services.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<List<NotificationEntity>> getNotifications() {
    return sl<NotificationServices>().getNotifications();
  }

  @override
  Future<void> markNotificationAsRead(String id) {
    return sl<NotificationServices>().markNotificationAsRead(id);
  }
}
