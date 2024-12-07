import 'core/constants/exports.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/signup.dart';
import 'package:get_it/get_it.dart';

import 'features/contacts/domain/usecases/add_contact.dart';
import 'features/contacts/domain/usecases/get_all_contacts.dart';
import 'features/contacts/domain/usecases/update_contact.dart';

final sl = GetIt.instance;

Future<void> initializeInjection() async {
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
  sl.registerSingleton<DeleteContactUsecase>(DeleteContactUsecase());
  sl.registerSingleton<GetAllUsersUsecase>(GetAllUsersUsecase());
  sl.registerSingleton<GetUserByIdUsecase>(GetUserByIdUsecase());

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
}
