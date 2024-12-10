import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/core/constants/exports.dart';
import 'package:smart_crm_app/core/resources/generic_state.dart';
import 'package:smart_crm_app/injection_container.dart';

class NotificationCubit extends Cubit<GenericState> {
  NotificationCubit() : super(const GenericState(isLoading: true));

  Future<void> fetchNotifications() async {
    try {
      final notifications = await sl<GetNotificationUsecase>().call();
      emit(state.copyWith(
          data: notifications, isSuccess: true, isLoading: false));
    } catch (error) {
      emit(state.copyWith(failure: error.toString()));
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await sl<MarkNotificationAsReadUsecase>().call(params: id);
      fetchNotifications();
    } catch (error) {
      emit(state.copyWith(failure: error.toString()));
    }
  }
}
