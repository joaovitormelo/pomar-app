import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pomar_app/features/auth/data/datasources/network_source.dart';
import 'package:pomar_app/features/auth/data/datasources/storage_source.dart';
import 'package:pomar_app/features/auth/data/repository/login_repository.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/data/datasources/server_source.dart';
import 'package:pomar_app/features/auth/data/models/session_model.dart';
import 'package:pomar_app/features/auth/data/models/user_model.dart';
import 'package:pomar_app/features/auth/domain/entities/person.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/domain/entities/user.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login.dart';

class MockServerSource extends Mock implements ServerSourceContract {}

class MockStorageSource extends Mock implements StorageSourceContract {}

class MockNetworkInfo extends Mock implements NetworkInfoContract {}

main() {
  LoginParams tParams =
      LoginParams(email: "valid_email", password: "valid_password");
  LoginParams tParamsWrong = LoginParams(
      email: "possibly_wrong_email", password: "possibly_wrong_password");
  Person tPerson = Person(
      idPerson: 1,
      name: "person_name",
      email: "person_email",
      phone: "person_phone");
  User tUser =
      User(idUser: 1, person: tPerson, password: "user_password", typeUser: 0);
  Session tSession = Session(
      idSession: 1, user: tUser, jwtToken: "jwtToken", loginTime: "loginTime");
  SessionModel tSessionModel = SessionModel(
      idSession: tSession.idSession,
      user: UserModel.fromEntity(tUser),
      jwtToken: tSession.jwtToken,
      loginTime: tSession.loginTime);
  late MockServerSource mockServerSource;
  late MockStorageSource mockStorageSource;
  late MockNetworkInfo mockNetworkInfo;
  late LoginRepository sut;

  setUp(() {
    mockServerSource = MockServerSource();
    when(mockServerSource.doLogin(tParams))
        .thenAnswer((_) async => tSessionModel);
    mockStorageSource = MockStorageSource();
    mockNetworkInfo = MockNetworkInfo();
    when(mockNetworkInfo.checkConnection()).thenAnswer((_) async => true);
    sut = LoginRepository(
        serverSource: mockServerSource,
        storageSource: mockStorageSource,
        networkInfo: mockNetworkInfo);
  });

  checkOnline(body) {
    test("it should check if device is online", () async {
      await sut.doLogin(tParams);

      verify(mockNetworkInfo.checkConnection());
    });

    test("it should throw NetworkError if device has no connection", () {
      when(mockNetworkInfo.checkConnection()).thenAnswer((_) async => false);

      Function call = sut.doLogin;

      expect(() => call(tParams), throwsA(const TypeMatcher<NetworkError>()));
    });

    body();
  }

  group("Test LoginRepository", () {
    group("doLogin", () {
      checkOnline(() {
        test("it should call doLogin from serverSource with correct parameters",
            () async {
          await sut.doLogin(tParams);

          verify(mockServerSource.doLogin(tParams));
        });

        group("if doLogin throws", () {
          test('should rethrow UserNotFoundError if doLogin throws it',
              () async {
            when(mockServerSource.doLogin(tParamsWrong))
                .thenThrow(UserNotFoundError());

            Function call = sut.doLogin;

            expect(() => call(tParamsWrong),
                throwsA(const TypeMatcher<UserNotFoundError>()));
          });

          test('should rethrow UnauthorizedError if doLogin throws it',
              () async {
            when(mockServerSource.doLogin(tParamsWrong))
                .thenThrow(UnauthorizedError());

            Function call = sut.doLogin;

            expect(() => call(tParamsWrong),
                throwsA(const TypeMatcher<UnauthorizedError>()));
          });

          test('should rethrow ConnectionError if doLogin throws it', () async {
            when(mockServerSource.doLogin(tParams))
                .thenThrow(ConnectionError());

            Function call = sut.doLogin;

            expect(() => call(tParams),
                throwsA(const TypeMatcher<ConnectionError>()));
          });

          test('should rethrow ValidationError if doLogin throws it', () async {
            when(mockServerSource.doLogin(tParamsWrong))
                .thenThrow(ValidationError());

            Function call = sut.doLogin;

            expect(() => call(tParamsWrong),
                throwsA(const TypeMatcher<ValidationError>()));
          });

          test('should rethrow ServerError if doLogin throws it', () async {
            when(mockServerSource.doLogin(tParams)).thenThrow(ServerError());

            Function call = sut.doLogin;

            expect(
                () => call(tParams), throwsA(const TypeMatcher<ServerError>()));
          });

          test('should rethrow NetworkError if doLogin throws it', () async {
            when(mockServerSource.doLogin(tParams)).thenThrow(NetworkError());

            Function call = sut.doLogin;

            expect(() => call(tParams),
                throwsA(const TypeMatcher<NetworkError>()));
          });
        });

        test("it should return valid session", () async {
          Session? session = await sut.doLogin(tParams);

          expect(session, equals(tSessionModel));
        });
      });
    });

    group("saveSession", () {
      checkOnline(() {
        test(
          "it should call saveSession from StorageSource with correct parameters",
          () async {
            await sut.saveSession(tSession);

            verify(mockStorageSource.saveSession(tSessionModel));
          },
        );

        test(
          "it should rethrow StorageError if StorageSource throws it",
          () {
            when(mockStorageSource.saveSession(tSessionModel))
                .thenThrow(StorageError());

            Function call = sut.saveSession;

            expect(call(tSession), throwsA(const TypeMatcher<StorageError>()));
          },
        );
      });
    });
  });
}
