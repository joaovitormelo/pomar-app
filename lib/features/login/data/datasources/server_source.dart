import 'package:pomar_app/features/login/data/models/session_model.dart';
import 'package:pomar_app/features/login/domain/usecases/do_login.dart';

abstract class ServerSourceContract {
  Future<SessionModel>? doLogin(LoginParams params);
}
