import '../../../../core/usecase/usecase.dart';
import '../../../../injection_container.dart';
import '../entities/notification_entity.dart';
import '../repository/notification_repository.dart';

class GetNotificationUsecase extends Usecase<List<NotificationEntity>, void> {
  @override
  Future<List<NotificationEntity>> call({void params}) async {
    return await sl<NotificationRepository>().getNotifications();
  }
}
