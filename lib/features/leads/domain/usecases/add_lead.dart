import 'package:smart_crm_app/features/leads/domain/entities/lead_entity.dart';
import 'package:smart_crm_app/features/leads/domain/repository/lead_repository.dart';
import 'package:smart_crm_app/injection_container.dart';

import '../../../../core/usecase/usecase.dart';

class AddLeadUsecase extends Usecase<void, LeadEntity> {
  @override
  Future<void> call({LeadEntity? params}) async {
    return await sl<LeadRepository>().addLead(params!);
  }
}
