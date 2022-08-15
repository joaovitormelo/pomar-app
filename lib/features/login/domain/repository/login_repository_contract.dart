import 'package:pomar_app/features/login/domain/usecases/do_login.dart';

import '../entities/session.dart';

abstract class LoginRepositoryContract {
  Future<Session>? doLogin(LoginParams params);
  Future<Session>? saveSession(Session? session);
}
