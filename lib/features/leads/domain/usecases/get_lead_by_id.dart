import 'package:smart_crm_app/core/usecase/usecase.dart';

import '../../../../injection_container.dart';
import '../entities/lead_entity.dart';
import '../repository/lead_repository.dart';

class GetLeadByIdUsecase extends Usecase<LeadEntity, String> {
  @override
  Future<LeadEntity> call({String? params}) async {
    return await sl<LeadRepository>().getLeadById(params!);
  }
}
