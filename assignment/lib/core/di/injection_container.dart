import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase_options.dart';
import '../network/dio_client.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/local_demo_auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../theme/theme_cubit.dart';
import '../../features/employee/data/datasources/employee_local_data_source.dart';
import '../../features/employee/data/datasources/employee_remote_data_source.dart';
import '../../features/employee/data/repositories/employee_repository_impl.dart';
import '../../features/employee/domain/repositories/employee_repository.dart';
import '../../features/employee/domain/usecases/employee_usecases.dart';
import '../../features/employee/presentation/bloc/employee_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Network (Dio)
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  bool isFirebaseReady = false;
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    isFirebaseReady = Firebase.apps.isNotEmpty;
  } catch (_) {
    // Falls back to demo auth when Firebase options are unconfigured or unsupported platform
    isFirebaseReady = false;
  }

  // Auth - Data Source
  if (isFirebaseReady) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => FirebaseAuthRemoteDataSourceImpl(),
    );
  } else {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => LocalDemoAuthRemoteDataSourceImpl(sl<SharedPreferences>()),
    );
  }

  // Auth - Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // Auth - Use Cases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GoogleSignInUseCase>(
    () => GoogleSignInUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetAuthStateStreamUseCase>(
    () => GetAuthStateStreamUseCase(sl<AuthRepository>()),
  );

  // Auth - BLoC
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      googleSignInUseCase: sl<GoogleSignInUseCase>(),
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      getAuthStateStreamUseCase: sl<GetAuthStateStreamUseCase>(),
    ),
  );

  // Theme Cubit
  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(sl<SharedPreferences>()),
  );

  // Employee - Local Data Source
  sl.registerLazySingleton<EmployeeLocalDataSource>(
    () => EmployeeLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Employee - Remote Data Source
  sl.registerLazySingleton<EmployeeRemoteDataSource>(
    () => EmployeeRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Employee - Repository
  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(
      remoteDataSource: sl<EmployeeRemoteDataSource>(),
      localDataSource: sl<EmployeeLocalDataSource>(),
    ),
  );

  // Employee - Use Cases
  sl.registerLazySingleton<GetEmployeesUseCase>(
    () => GetEmployeesUseCase(sl<EmployeeRepository>()),
  );
  sl.registerLazySingleton<GetEmployeeByIdUseCase>(
    () => GetEmployeeByIdUseCase(sl<EmployeeRepository>()),
  );
  sl.registerLazySingleton<CreateEmployeeUseCase>(
    () => CreateEmployeeUseCase(sl<EmployeeRepository>()),
  );
  sl.registerLazySingleton<UpdateEmployeeUseCase>(
    () => UpdateEmployeeUseCase(sl<EmployeeRepository>()),
  );
  sl.registerLazySingleton<DeleteEmployeeUseCase>(
    () => DeleteEmployeeUseCase(sl<EmployeeRepository>()),
  );
  sl.registerLazySingleton<GetCountriesUseCase>(
    () => GetCountriesUseCase(sl<EmployeeRepository>()),
  );

  // Employee - BLoC
  sl.registerFactory<EmployeeBloc>(
    () => EmployeeBloc(
      getEmployeesUseCase: sl<GetEmployeesUseCase>(),
      createEmployeeUseCase: sl<CreateEmployeeUseCase>(),
      updateEmployeeUseCase: sl<UpdateEmployeeUseCase>(),
      deleteEmployeeUseCase: sl<DeleteEmployeeUseCase>(),
    ),
  );
}
