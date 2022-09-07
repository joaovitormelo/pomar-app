import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/data/datasources/network_source.dart';
import 'package:pomar_app/features/auth/data/datasources/server_source.dart';
import 'package:pomar_app/features/auth/data/datasources/storage_source.dart';
import 'package:pomar_app/features/auth/data/models/session_model.dart';
import 'package:pomar_app/features/auth/domain/entities/person.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/domain/entities/user.dart';
import 'package:pomar_app/features/auth/domain/repository/login_repository_contract.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login.dart';

class LoginRepository implements LoginRepositoryContract {
  ServerSourceContract serverSource;
  StorageSourceContract storageSource;
  NetworkInfoContract networkInfo;

  LoginRepository(
      {required this.serverSource,
      required this.storageSource,
      required this.networkInfo});

  @override
  Future<Session>? doLogin(LoginParams params) async {
    if (!(await networkInfo.checkConnection() as bool)) {
      throw NetworkError();
    }
    SessionModel? session = await serverSource.doLogin(params);
    return session as Session;
  }

  @override
  Future<void>? saveSession(Session? session) async {
    await storageSource
        .saveSession(SessionModel.fromEntity(session as Session));
  }

  @override
  Future<void>? logout(int idSession) async {
    if (!(await networkInfo.checkConnection() as bool)) {
      throw NetworkError();
    }
    await serverSource.logout(idSession);
  }

  @override
  Future<void>? removeSavedSession() async {
    await storageSource.removeSavedSession();
  }

  @override
  Future<Session> getSavedSession() async {
    return await storageSource.getSavedSession();
  }

  @override
  Future<void> validateSession(Session session) async {}
}
