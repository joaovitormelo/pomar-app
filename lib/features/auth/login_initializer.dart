import 'package:get_it/get_it.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/features/auth/data/datasources/network_source.dart';
import 'package:pomar_app/features/auth/data/datasources/server_source.dart';
import 'package:pomar_app/features/auth/data/datasources/storage_source.dart';
import 'package:pomar_app/features/auth/data/repository/login_repository.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login_with_stored_session.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_validate_session.dart';
import 'package:pomar_app/features/auth/domain/usecases/logout.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';

class LoginInitializer {
  final DoValidateSession doValidateSession;

  final LoginRepository loginRepository;

  final ServerSource serverSource;
  final StorageSource storageSource;
  final NetworkInfo networkInfo;

  LoginInitializer(
      {required this.doValidateSession,
      required this.loginRepository,
      required this.serverSource,
      required this.storageSource,
      required this.networkInfo});

  Future<void> init() async {
    DoLogin doLogin = DoLogin(LoginRepository: loginRepository);
    Logout logout = Logout(loginRepository: loginRepository);
    DoLoginWithStoredSession doLoginWithStoredSession =
        DoLoginWithStoredSession(loginRepository: loginRepository);

    Globals.authBloc =
        AuthBloc(doLoginWithStoredSession: doLoginWithStoredSession);
    Globals.loginBloc =
        LoginBloc(doLoginUseCase: doLogin, authBloc: Globals.authBloc);
    Globals.logoutBloc = LogoutBloc(
        doValidateSession: doValidateSession,
        logoutUsecase: logout,
        authBloc: Globals.authBloc);
  }
}
