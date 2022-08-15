import 'package:pomar_app/core/routes/router.dart';
import 'package:pomar_app/core/routes/routes.dart';
import 'package:pomar_app/features/login/domain/entities/session.dart';
import 'package:pomar_app/features/login/domain/repository/login_repository_contract.dart';

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

class DoLogin {
  final LoginRepositoryContract loginRepository;
  final RouterContract router;

  DoLogin({required this.loginRepository, required this.router});

  Future<Session?> call(LoginParams params) async {
    Session? session = await loginRepository.doLogin(params);
    await loginRepository.saveSession(session);
    if (session?.user.typeUser == 0) {
      router.redirect(Routes.homeAdmin);
    } else {
      router.redirect(Routes.homeEmployee);
    }
    return session;
  }
}
