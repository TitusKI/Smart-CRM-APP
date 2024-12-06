import 'package:smart_crm_app/features/leads/domain/entities/lead_entity.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../injection_container.dart';
import '../repository/lead_repository.dart';

class RejectLeadUsecase extends Usecase<void, LeadEntity> {
  @override
  Future<void> call({LeadEntity? params}) async {
    return await sl<LeadRepository>().rejectLead(params!);
  }
}
