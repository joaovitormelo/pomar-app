import 'package:pomar_app/features/auth/data/repository/login_repository.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';

class DoValidateSession {
  final LoginRepository loginRepository;

  DoValidateSession({required this.loginRepository});

  Future<void> call(Session session) async {
    await loginRepository.validateSession(session);
  }
}
