import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/core/constants/exports.dart';
import '../../../../core/resources/generic_state.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/lead_entity.dart';

class LeadCubit extends Cubit<GenericState> {
  LeadCubit() : super(const GenericState(isLoading: true));

  // Add a lead
  Future<void> addLead(LeadEntity lead) async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl<AddLeadUsecase>().call(params: lead);
      fetchLeads();
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  // Update a lead
  Future<void> updateLead(LeadEntity lead) async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl<UpdateLeadUsecase>().call(params: lead);
      fetchLeads(); // Refresh leads after updating
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  // Delete a lead
  Future<void> deleteLead(String id) async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl<DeleteLeadUsecase>().call(params: id);
      fetchLeads();
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  // Fetch all leads
  Future<void> fetchLeads() async {
    emit(state.copyWith(isLoading: true));
    try {
      final leads = await sl<GetLeadsUsecase>().call();
      emit(GenericState(data: leads, isSuccess: true));
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  Future<void> getLeadsById() async {
    emit(state.copyWith(isLoading: true));
    try {
      final leads = await sl<GetLeadByIdUsecase>().call();
      emit(GenericState(data: leads, isSuccess: true));
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  Future<void> rejectLead(LeadEntity lead) async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl<RejectLeadUsecase>().call(params: lead);
      fetchLeads();
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  Future<void> approveLead(LeadEntity lead) async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl<ApproveLeadUsecase>().call(params: lead);
      fetchLeads();
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  Future<void> getApprovalQueue() async {
    emit(state.copyWith(isLoading: true));
    try {
      final data = await sl<LeadApprovalQueueUsecase>().call();
      emit(state.copyWith(data: data, isSuccess: true));
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }
}
