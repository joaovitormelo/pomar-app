import 'package:pomar_app/core/routes/routes.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/domain/repository/login_repository_contract.dart';

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

class DoLogin {
  final LoginRepositoryContract LoginRepository;

  DoLogin({required this.LoginRepository});

  Future<Session?> call(LoginParams params) async {
    Session? session = await LoginRepository.doLogin(params);
    await LoginRepository.saveSession(session);
    return session;
  }
}
