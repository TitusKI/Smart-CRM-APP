import '../entities/lead_entity.dart';

abstract class LeadRepository {
  Future<void> addLead(LeadEntity lead);
  Future<void> deleteLead(String id);
  Future<void> updateLead(LeadEntity lead);
  Future<List<LeadEntity>> getAllLeads({String? status});
  Future<LeadEntity> getLeadById(String id);
  // ONLY ADMIN
  Future<void> rejectLead(LeadEntity lead);
  Future<void> approveLead(LeadEntity lead);
  Future<List<LeadEntity>> getApprovalQueue();
}
