import 'package:dio/dio.dart';
import 'package:smart_crm_app/features/auth/data/services/local/storage_services.dart';
import 'package:smart_crm_app/features/leads/data/models/lead_model.dart';

import '../../../../../core/constants/constant.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/lead_entity.dart';

abstract class LeadServices {
  Future<void> addLead(LeadEntity lead);
  Future<void> deleteLead(String id);
  Future<void> updateLead(LeadEntity lead);
  Future<List<LeadEntity>> getAllLeads({String? status});
  Future<LeadEntity> getLeadById(String id);
  // Admin only
  Future<void> rejectLead(LeadEntity lead);
  Future<void> approveLead(LeadEntity lead);
  Future<List<LeadEntity>> getApprovalQueue();
}

class LeadServicesImpl implements LeadServices {
  final storageServices = sl<StorageServices>();

  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstant.BASE_URL, headers: {
    'Content-Type': 'application/json',
  }));
  LeadServicesImpl() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        const pathsWithHeaders = [
          "/leads",
          "/leads/:id",
          "/leads/admin/approval-queue",
          "/leads/:id/approve",
          "/leads/:id/reject",
        ];
        if (pathsWithHeaders.contains(options.path)) {
          if (pathsWithHeaders.contains(options.path)) {
            print("Path with Header for access Token");
            final token = storageServices.getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              print("Access Token with The same path headers");
              print(token);
            }
          }
        }
        return handler.next(options);
      },
    ));
  }

  @override
  Future<void> addLead(LeadEntity lead) async {
    final leadInfo = LeadModel.fromEntity(lead);
    try {
      final response = await _dio.post("/leads", data: leadInfo.toJson());
      final data = response.data;
      if (data == null || data['token'] == null) {
        throw Exception("Adding lead failed: No access token received");
      }
      print("Lead added successfully");
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
        throw Exception("Unexpected error :$err");
      }
    }
  }

  @override
  Future<void> deleteLead(String id) async {
    try {
      final response = await _dio.delete("/leads/$id");
      final data = response.data;
      if (data == null || data['token'] == null) {
        throw Exception("Deleting lead failed: No access token received");
      }
      print("Contact deleted successfully");
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
      }
    }
  }

  @override
  Future<List<LeadEntity>> getAllLeads({String? status}) async {
    try {
      final response = await _dio.get("/leads");
      final data = response.data;
      if (data == null || data['token'] == null) {
        throw Exception("Getting leads failed: No access token received");
      }
      print("leads fetched successfully");
      return (data).map((e) => LeadModel.fromJson(e).toEntity()).toList()
          as List<LeadEntity>;
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
      }
    }
    return [];
  }

  @override
  Future<LeadEntity> getLeadById(String id) async {
    try {
      final response = await _dio.get("/laeds/$id");
      final data = response.data;
      if (data == null || data['token'] == null) {
        throw Exception("Getting contact failed: No access token received");
      }
      print("Lead fetched successfully");
      return LeadModel.fromJson(data).toEntity();
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
      }
    }
    return LeadModel.fromJson({}).toEntity();
  }

  @override
  Future<void> updateLead(LeadEntity lead) async {
    try {
      await _dio.patch("/leads/${lead.id}",
          data: LeadModel.fromEntity(lead).toJson());
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
      }
    }
  }

  @override
  Future<void> approveLead(LeadEntity lead) async {
    try {
      final response = await _dio.post(
        '/leads/${lead.id}/approve',
      );

      if (response.statusCode == 200) {
        print('Lead approved successfully');
      } else {
        throw Exception('Failed to approve lead');
      }
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
      }
    }
  }

  @override
  Future<List<LeadEntity>> getApprovalQueue() async {
    try {
      final response = await _dio.get("/leads/admin/approval-queue");
      final data = response.data;
      if (data == null || data['token'] == null) {
        throw Exception("Getting leads failed: No access token received");
      }
      print("leads fetched successfully");
      return (data).map((e) => LeadModel.fromJson(e).toEntity()).toList()
          as List<LeadEntity>;
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
      }
    }
    return [];
  }

  @override
  Future<void> rejectLead(LeadEntity lead) async {
    try {
      final response = await _dio.post('/leads/${lead.id}/reject',
          data: {"rejectionNotes": lead.rejectionNotes});

      if (response.statusCode == 200) {
        print('Lead rejected successfully');
      } else {
        throw Exception('Failed to reject lead');
      }
    } catch (err) {
      if (err is DioException) {
        if (err.response != null) {
          print("ERROR CATCHED: ${err.response!.data}");
        }
      } else {
        print("Unexpected error :$err");
      }
    }
  }
}
