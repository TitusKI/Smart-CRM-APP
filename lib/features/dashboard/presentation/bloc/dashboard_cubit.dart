import 'package:bloc/bloc.dart';

import '../../../../core/resources/generic_state.dart';
import '../../domain/entities/dashboarddata.dart';

class DashboardCubit extends Cubit<GenericState<dynamic>> {
  DashboardCubit() : super(const GenericState());

  void loadDashboardData() async {
    emit(state.copyWith(isLoading: true)); // Start loading state

    try {
      // Simulate data fetching
      await Future.delayed(const Duration(seconds: 2));
      final data = DashboardData(
        totalContacts: 45,
        activeLeads: 12,
        pendingLeads: 8,
        recentActivities: [
          Activity(title: "John Doe updated a lead", timestamp: "2 hours ago"),
          Activity(
              title: "New contact added: Jane Smith", timestamp: "5 hours ago"),
        ],
      );

      emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          data: data)); // Loaded successfully
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, failure: e.toString()));
    }
  }
}
