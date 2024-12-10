import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/core/resources/generic_state.dart';
import 'package:smart_crm_app/features/dashboard/domain/entities/dashboarddata.dart';
import 'package:smart_crm_app/injection_container.dart';

import '../../../contacts/domain/usecases/get_all_contacts.dart';
import '../../../leads/domain/usecases/get_leads.dart';

class DashboardCubit extends Cubit<GenericState> {
  DashboardCubit() : super(const GenericState(isLoading: true));

  Future<void> fetchDashboardData() async {
    try {
      // Fetch contacts
      final contacts = await sl<GetAllContactsUsecase>().call();
      final totalContacts = contacts.length;

      // Fetch leads
      final leads = await sl<GetLeadsUsecase>().call();
      final activeLeads =
          leads.where((lead) => lead.status == 'Approved').length;
      final pendingLeads =
          leads.where((lead) => lead.status == 'Pending').length;
      final rejectedLeads =
          leads.where((lead) => lead.status == 'Rejected').length;

      final recentActivities = [
        {'title': 'Kidane updated a lead', 'timestamp': '2 hours ago'},
        {'title': 'New contact added: Kaleab K', 'timestamp': '5 hours ago'},
      ];

      final dashboardData = DashboardData(
        totalContacts: totalContacts,
        activeLeads: activeLeads,
        pendingLeads: pendingLeads,
        rejectedLeads: rejectedLeads,
        recentActivities: recentActivities,
      );

      emit(state.copyWith(data: dashboardData, isSuccess: true));
    } catch (error) {
      emit(state.copyWith(failure: error.toString()));
    }
  }
}
