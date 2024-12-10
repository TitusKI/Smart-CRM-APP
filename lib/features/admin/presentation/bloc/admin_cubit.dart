import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/core/constants/exports.dart';
import 'package:smart_crm_app/features/auth/domain/entities/signup_entity.dart';
import 'package:smart_crm_app/features/auth/domain/usecases/delete_user.dart';
import '../../../../../core/resources/generic_state.dart';
import '../../../../../injection_container.dart';

class AdminCubit extends Cubit<GenericState> {
  AdminCubit() : super(const GenericState(isLoading: true));

  Future<void> getAllUsers() async {
    emit(state.copyWith(isLoading: true));
    try {
      final users = await sl<GetAllUsersUsecase>().call();
      emit(GenericState(data: users, isSuccess: true));
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  Future<void> getUserById(String id) async {
    emit(state.copyWith(isLoading: true));
    try {
      final users = await sl<GetContactByIdUsecase>().call(params: id);
      emit(GenericState(data: users, isSuccess: true));
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  Future<void> createUser(UserEntity contact) async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl<CreateUserUsecase>().call(params: contact);
      getAllUsers();
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }

  Future<void> deleteUser(String id) async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl<DeleteUserUsecase>().call(params: id);
      getAllUsers();
    } catch (error) {
      emit(state.copyWith(isLoading: false, failure: error.toString()));
    }
  }
}
