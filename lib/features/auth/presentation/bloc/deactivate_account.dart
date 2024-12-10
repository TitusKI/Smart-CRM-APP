import 'package:bloc/bloc.dart';
import 'package:smart_crm_app/core/constants/exports.dart';

import '../../../../../core/resources/generic_state.dart';
import '../../../../../injection_container.dart';

class DeactivateMyAccount extends Cubit<GenericState> {
  DeactivateMyAccount() : super(const GenericState());
  Future<void> deleteAccount() async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl<DeleteAccountUsecase>().call();
      // sl<AuthRepository>().signOut();
      emit(state.copyWith(isSuccess: true, isLoading: false, failure: null));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        failure: e.toString(),
      ));
    }
  }
}
