import 'package:smart_crm_app/core/usecase/usecase.dart';

import '../../../../injection_container.dart';
import '../repository/lead_repository.dart';

class DeleteLeadUsecase extends Usecase<void, String> {
  @override
  Future<void> call({String? params}) async {
    return await sl<LeadRepository>().deleteLead(params!);
  }
}
