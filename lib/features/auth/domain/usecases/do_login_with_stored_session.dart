import 'dart:developer';

import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/domain/repository/login_repository_contract.dart';

class DoLoginWithStoredSession {
  final LoginRepositoryContract loginRepository;

  DoLoginWithStoredSession({required this.loginRepository});

  Future<Session?> call() async {
    Session? session = await loginRepository.getSavedSession();
    return session;
  }
}
