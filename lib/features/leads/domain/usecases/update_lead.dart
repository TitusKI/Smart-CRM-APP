import 'package:smart_crm_app/core/usecase/usecase.dart';

import '../../../../injection_container.dart';
import '../entities/lead_entity.dart';
import '../repository/lead_repository.dart';

class UpdateLeadUsecase extends Usecase<void, LeadEntity> {
  @override
  Future<void> call({LeadEntity? params}) async {
    return await sl<LeadRepository>().updateLead(params!);
  }
}
