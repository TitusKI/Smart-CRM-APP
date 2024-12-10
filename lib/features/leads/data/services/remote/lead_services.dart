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

  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstant.BASE_URL));
  LeadServicesImpl() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        const pathsWithHeaders = [
          "/leads",

          // "/leads/admin/approval-queue"
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
      if (data == null) {
        throw Exception("Adding lead failed");
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
      final response = await _dio.delete("/leads/$id",
          options: Options(headers: {
            "Authorization": "Bearer ${storageServices.getToken()}"
          }));
      final data = response.data;
      if (data == null) {
        throw Exception("Deleting lead failed");
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
      print("Trying to get all leads");
      final response = await _dio.get("/leads");
      final data = response.data;
      print(data);
      if (data['data']['leads'] == null) {
        throw Exception("Getting leads failed");
      }
      print("leads fetched successfully");
      return (data['data']['leads'] as List)
          .map((e) => LeadModel.fromJson(e).toEntity())
          .toList();
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
      final response = await _dio.get("/laeds/$id",
          options: Options(headers: {
            "Authorization": "Bearer ${storageServices.getToken()}"
          }));
      final data = response.data;
      print(data);
      if (data == null) {
        throw Exception("Getting contact failed");
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
    print("Trying to Update the lead");
    final leadinfo = LeadModel.fromEntity(lead).toJson();
    print(lead.id);
    try {
      print(LeadModel.fromEntity(lead).toJson());
      final response = await _dio.put("/leads/${lead.id}",
          data: leadinfo,
          options: Options(headers: {
            "Authorization": "Bearer ${storageServices.getToken()}"
          }));
      print(response.data);
      print("Lead updated successfully");
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
      print("Trying to approve the lead");
      final response = await _dio.post('/leads/${lead.id}/approve',
          options: Options(headers: {
            "Authorization": "Bearer ${storageServices.getToken()}"
          }));
      print(response.data);

      print('Lead approved successfully');
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
      print("Trying to get approval queue");
      final response = await _dio.get("/leads/admin/approval-queue",
          options: Options(headers: {
            "Authorization": "Bearer ${storageServices.getToken()}"
          }));
      final data = response.data;
      print(data);
      if (data == null) {
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
      print("Tryig to reject the lead");
      final response = await _dio.post('/leads/${lead.id}/reject',
          options: Options(headers: {
            "Authorization": "Bearer ${storageServices.getToken()}"
          }),
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
