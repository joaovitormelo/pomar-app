import 'package:pomar_app/features/auth/data/models/session_model.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login.dart';

abstract class LoginRepositoryContract {
  Future<Session>? doLogin(LoginParams params);
  Future<void>? saveSession(Session? session);
  Future<void>? logout(int idSession);
  Future<void>? removeSavedSession();
  Future<Session> getSavedSession();
  Future<void> validateSession(Session session);
}
