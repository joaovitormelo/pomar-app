import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/features/auth/data/datasources/network_source.dart';
import 'package:pomar_app/features/auth/data/datasources/server_source.dart';
import 'package:pomar_app/features/auth/data/datasources/storage_source.dart';
import 'package:pomar_app/features/auth/data/repository/login_repository.dart';
import 'package:pomar_app/features/auth/domain/repository/login_repository_contract.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login_with_stored_session.dart';
import 'package:pomar_app/features/auth/domain/usecases/logout.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';

class LoginInitializer {
  final GetIt sl;
  final Dio dio;

  LoginInitializer({required this.sl, required this.dio});

  Future<void> init() async {
    sl.registerLazySingleton(() => AuthBloc(doLoginWithStoredSession: sl()));
    sl.registerLazySingleton(
      () => LoginBloc(doLoginUseCase: sl(), authBloc: sl()),
    );
    sl.registerLazySingleton(
      () => LogoutBloc(logoutUsecase: sl(), authBloc: sl()),
    );

    sl.registerLazySingleton(() => DoLogin(LoginRepository: sl()));
    sl.registerLazySingleton(() => Logout(loginRepository: sl()));
    sl.registerLazySingleton(
      () => DoLoginWithStoredSession(loginRepository: sl()),
    );

    sl.registerLazySingleton<LoginRepositoryContract>(
      () => LoginRepository(
        serverSource: sl(),
        storageSource: sl(),
        networkInfo: sl(),
      ),
    );

    sl.registerLazySingleton<ServerSourceContract>(
        () => ServerSource(dio: sl()));
    sl.registerLazySingleton<StorageSourceContract>(() => StorageSource());
    sl.registerLazySingleton<NetworkInfoContract>(() => NetworkInfo());
  }
}
