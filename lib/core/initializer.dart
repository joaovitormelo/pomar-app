import 'package:get_it/get_it.dart';
import 'package:pomar_app/features/auth/data/datasources/network_source.dart';
import 'package:pomar_app/features/auth/data/datasources/server_source.dart';
import 'package:pomar_app/features/auth/data/datasources/storage_source.dart';
import 'package:pomar_app/features/auth/data/repository/login_repository.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_validate_session.dart';
import 'package:pomar_app/features/auth/login_initializer.dart';

class Initializer {
  Future<void> init() async {
    ServerSource serverSource = ServerSource();
    StorageSource storageSource = StorageSource();
    NetworkInfo networkInfo = NetworkInfo();

    LoginRepository loginRepository = LoginRepository(
        serverSource: serverSource,
        storageSource: storageSource,
        networkInfo: networkInfo);

    DoValidateSession doValidateSession =
        DoValidateSession(loginRepository: loginRepository);

    await LoginInitializer(
            doValidateSession: doValidateSession,
            loginRepository: loginRepository,
            serverSource: serverSource,
            storageSource: storageSource,
            networkInfo: networkInfo)
        .init();
  }
}
