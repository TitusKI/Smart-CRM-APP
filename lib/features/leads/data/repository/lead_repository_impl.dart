import 'package:smart_crm_app/features/leads/domain/entities/lead_entity.dart';
import 'package:smart_crm_app/features/leads/domain/repository/lead_repository.dart';

import '../../../../injection_container.dart';
import '../services/remote/lead_services.dart';

class LeadRepositoryImpl implements LeadRepository {
  @override
  Future<void> addLead(LeadEntity lead) {
    return sl<LeadServices>().addLead(lead);
  }

  @override
  Future<void> deleteLead(String id) {
    return sl<LeadServices>().deleteLead(id);
  }

  @override
  Future<List<LeadEntity>> getAllLeads({String? status}) {
    return sl<LeadServices>().getAllLeads(status: status);
  }

  @override
  Future<LeadEntity> getLeadById(String id) {
    return sl<LeadServices>().getLeadById(id);
  }

  @override
  Future<void> updateLead(LeadEntity lead) {
    return sl<LeadServices>().updateLead(lead);
  }

  @override
  Future<void> approveLead(LeadEntity lead) {
    return sl<LeadServices>().approveLead(lead);
  }

  @override
  Future<List<LeadEntity>> getApprovalQueue() {
    return sl<LeadServices>().getApprovalQueue();
  }

  @override
  Future<void> rejectLead(LeadEntity lead) {
    return sl<LeadServices>().rejectLead(lead);
  }
}
