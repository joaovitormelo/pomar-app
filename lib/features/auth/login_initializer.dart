import 'package:get_it/get_it.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/features/auth/data/datasources/network_source.dart';
import 'package:pomar_app/features/auth/data/datasources/server_source.dart';
import 'package:pomar_app/features/auth/data/datasources/storage_source.dart';
import 'package:pomar_app/features/auth/data/repository/login_repository.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login_with_stored_session.dart';
import 'package:pomar_app/features/auth/domain/usecases/logout.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';

class LoginInitializer {
  Future<void> init() async {
    NetworkInfo networkInfo = NetworkInfo();
    StorageSource storageSource = StorageSource();
    ServerSource serverSource = ServerSource();

    LoginRepository loginRepository = LoginRepository(
        serverSource: serverSource,
        storageSource: storageSource,
        networkInfo: networkInfo);

    DoLogin doLogin = DoLogin(LoginRepository: loginRepository);
    Logout logout = Logout(loginRepository: loginRepository);
    DoLoginWithStoredSession doLoginWithStoredSession =
        DoLoginWithStoredSession(loginRepository: loginRepository);

    Globals.authBloc =
        AuthBloc(doLoginWithStoredSession: doLoginWithStoredSession);
    Globals.loginBloc =
        LoginBloc(doLoginUseCase: doLogin, authBloc: Globals.authBloc);
    Globals.logoutBloc =
        LogoutBloc(logoutUsecase: logout, authBloc: Globals.authBloc);
  }
}
