import 'package:smart_crm_app/core/usecase/usecase.dart';

import '../../../../injection_container.dart';
import '../entities/lead_entity.dart';
import '../repository/lead_repository.dart';

class LeadApprovalQueueUsecase extends Usecase<List<LeadEntity>, void> {
  @override
  Future<List<LeadEntity>> call({void params}) async {
    return await sl<LeadRepository>().getApprovalQueue();
  }
}
