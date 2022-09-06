import 'package:pomar_app/features/auth/domain/repository/login_repository_contract.dart';

class Logout {
  final LoginRepositoryContract loginRepository;

  Logout({required this.loginRepository});

  call(int idSession) async {
    await loginRepository.logout(idSession);
    await loginRepository.removeSavedSession(idSession);
  }
}
