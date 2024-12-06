import 'package:smart_crm_app/core/usecase/usecase.dart';

import '../../../../injection_container.dart';
import '../entities/lead_entity.dart';
import '../repository/lead_repository.dart';

class GetLeadsUsecase extends Usecase<List<LeadEntity>, String> {
  @override
  Future<List<LeadEntity>> call({String? params}) async {
    return await sl<LeadRepository>().getAllLeads(status: params);
  }
}
