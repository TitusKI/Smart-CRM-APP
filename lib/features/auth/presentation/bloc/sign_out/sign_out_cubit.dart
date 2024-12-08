import 'package:bloc/bloc.dart';
import 'package:smart_crm_app/features/auth/domain/usecases/logout.dart';

import '../../../../../core/resources/generic_state.dart';
import '../../../../../injection_container.dart';

class SignOutCubit extends Cubit<GenericState> {
  SignOutCubit() : super(const GenericState());
  Future<void> signOut() async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl<LogoutUsecase>().call();
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
