import 'package:pomar_app/features/login/data/models/session_model.dart';
import 'package:pomar_app/features/login/domain/entities/session.dart';
import 'package:pomar_app/features/login/domain/usecases/do_login.dart';

abstract class LoginRepositoryContract {
  Future<Session>? doLogin(LoginParams params);
  Future<void>? saveSession(Session? session);
}
