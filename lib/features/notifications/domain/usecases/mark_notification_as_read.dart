import 'package:smart_crm_app/core/usecase/usecase.dart';
import 'package:smart_crm_app/features/notifications/domain/repository/notification_repository.dart';

import '../../../../injection_container.dart';

class MarkNotificationAsReadUsecase extends Usecase<void, String> {
  @override
  Future<void> call({String? params}) {
    return sl<NotificationRepository>().markNotificationAsRead(params!);
  }
}
