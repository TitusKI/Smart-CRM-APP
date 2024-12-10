import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_crm_app/features/auth/domain/usecases/delete_user.dart';
import 'package:smart_crm_app/features/auth/presentation/bloc/verification/verification_bloc.dart';

import 'package:smart_crm_app/features/common/bottom_navigation/bottom_navigation_bloc.dart';

import 'core/constants/exports.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/signup.dart';
import 'package:get_it/get_it.dart';

import 'features/auth/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'features/auth/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'features/contacts/domain/usecases/add_contact.dart';
import 'features/contacts/domain/usecases/get_all_contacts.dart';
import 'features/contacts/domain/usecases/update_contact.dart';
import 'features/dashboard/presentation/bloc/dashboard_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeInjection() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // local storage
  sl.registerSingleton<StorageServices>(await StorageServices().init());

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<ContactRepository>(() => ContactRepositoryImpl());
  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl());
  sl.registerLazySingleton<LeadRepository>(() => LeadRepositoryImpl());

// Services
  sl.registerLazySingleton<AuthServices>(() => AuthServicesImpl());
  sl.registerLazySingleton<ContactServices>(() => ContactServicesImpl());
  sl.registerLazySingleton<NotificationServices>(
      () => NotificationServicesImpl());
  sl.registerLazySingleton<LeadServices>(() => LeadServicesImpl());

  // Features
  // Auth
  sl.registerSingleton<LoginUsecase>(LoginUsecase());
  sl.registerSingleton<SignupUsecase>(SignupUsecase());
  sl.registerSingleton<LogoutUsecase>(LogoutUsecase());
  sl.registerSingleton<DeleteAccountUsecase>(DeleteAccountUsecase());
  sl.registerSingleton<CreateUserUsecase>(CreateUserUsecase());
  sl.registerSingleton<GetAllUsersUsecase>(GetAllUsersUsecase());
  sl.registerSingleton<GetUserByIdUsecase>(GetUserByIdUsecase());
  sl.registerSingleton<DeleteUserUsecase>(DeleteUserUsecase());

// Contact usecases
  sl.registerSingleton<AddContactUsecase>(AddContactUsecase());
  sl.registerSingleton<DeleteContactUsecase>(DeleteContactUsecase());
  sl.registerSingleton<GetAllContactsUsecase>(GetAllContactsUsecase());
  sl.registerSingleton<GetContactByIdUsecase>(GetContactByIdUsecase());
  sl.registerSingleton<UpdateContactUsecase>(UpdateContactUsecase());

// Notification usecases
  sl.registerSingleton<GetNotificationUsecase>(GetNotificationUsecase());
  sl.registerSingleton<MarkNotificationAsReadUsecase>(
      MarkNotificationAsReadUsecase());

// Lead usecases
  sl.registerSingleton<GetLeadsUsecase>(GetLeadsUsecase());
  sl.registerSingleton<AddLeadUsecase>(AddLeadUsecase());
  sl.registerSingleton<ApproveLeadUsecase>(ApproveLeadUsecase());
  sl.registerSingleton<DeleteLeadUsecase>(DeleteLeadUsecase());
  sl.registerSingleton<GetLeadByIdUsecase>(GetLeadByIdUsecase());
  sl.registerSingleton<LeadApprovalQueueUsecase>(LeadApprovalQueueUsecase());
  sl.registerSingleton<RejectLeadUsecase>(RejectLeadUsecase());
  sl.registerSingleton<UpdateLeadUsecase>(UpdateLeadUsecase());

  // blocs
  sl.registerFactory<SignInBloc>(() => SignInBloc());
  sl.registerFactory<SignUpBloc>(() => SignUpBloc());
  sl.registerFactory<BottomNavigationBloc>(() => BottomNavigationBloc());
  sl.registerFactory<VerificationBloc>(() => VerificationBloc());
  sl.registerFactory<DashboardCubit>(
      () => DashboardCubit()..fetchDashboardData());
}
