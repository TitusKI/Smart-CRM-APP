import 'package:smart_crm_app/features/auth/data/services/local/storage_services.dart';
import 'package:smart_crm_app/features/auth/data/services/remote/auth_services.dart';

import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/signup.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeInjection() async {
  // local storage
  sl.registerSingleton<StorageServices>(await StorageServices().init());
  // Features - Auth
  sl.registerSingleton<LoginUsecase>(LoginUsecase());
  sl.registerSingleton<SignupUsecase>(SignupUsecase());
  sl.registerSingleton<LogoutUsecase>(LogoutUsecase());

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<AuthServices>(() => AuthServicesImpl());
  // Data sources

  // Core
}
