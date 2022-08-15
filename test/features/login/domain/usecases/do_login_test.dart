import 'package:flutter_test/flutter_test.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/core/routes/router.dart';
import 'package:pomar_app/core/routes/routes.dart';
import 'package:pomar_app/features/login/domain/entities/person.dart';
import 'package:pomar_app/features/login/domain/entities/session.dart';
import 'package:mockito/mockito.dart';
import 'package:pomar_app/features/login/domain/entities/user.dart';
import 'package:pomar_app/features/login/domain/repository/login_repository_contract.dart';
import 'package:pomar_app/features/login/domain/usecases/do_login.dart';

class MockRouter extends Mock implements RouterContract {}

class MockLoginRepository extends Mock implements LoginRepositoryContract {}

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
  User tUserAdmin =
      User(idUser: 1, person: tPerson, password: "user_password", typeUser: 0);
  Session tSessionAdmin = Session(
      idSession: 1,
      user: tUserAdmin,
      jwtToken: "valid_token",
      loginTime: "valid_time");
  User tUserEmployee =
      User(idUser: 1, person: tPerson, password: "user_password", typeUser: 1);
  Session tSessionEmployee = Session(
      idSession: 1,
      user: tUserEmployee,
      jwtToken: "valid_token",
      loginTime: "valid_time");
  late MockRouter mockRouter;
  late MockLoginRepository mockLoginRepository;
  late DoLogin sut;

  setUp(() {
    mockRouter = MockRouter();
    mockLoginRepository = MockLoginRepository();
    when(mockLoginRepository.doLogin(tParams))
        .thenAnswer((_) async => tSession);
    sut = DoLogin(loginRepository: mockLoginRepository, router: mockRouter);
  });

  group("doLogin", () {
    test('should call doLogin from LoginRepository passing correct parameters',
        () async {
      await sut(tParams);

      verify(mockLoginRepository.doLogin(tParams));
    });

    group("if doLogin throws", () {
      test('should rethrow UserNotFoundError if doLogin throws it', () async {
        when(mockLoginRepository.doLogin(tParamsWrong))
            .thenThrow(UserNotFoundError());

        Function call = sut;

        expect(() => call(tParamsWrong),
            throwsA(const TypeMatcher<UserNotFoundError>()));
      });

      test('should rethrow UnauthorizedError if doLogin throws it', () async {
        when(mockLoginRepository.doLogin(tParamsWrong))
            .thenThrow(UnauthorizedError());

        Function call = sut;

        expect(() => call(tParamsWrong),
            throwsA(const TypeMatcher<UnauthorizedError>()));
      });

      test('should rethrow ConnectionError if doLogin throws it', () async {
        when(mockLoginRepository.doLogin(tParams)).thenThrow(ConnectionError());

        Function call = sut;

        expect(
            () => call(tParams), throwsA(const TypeMatcher<ConnectionError>()));
      });

      test('should rethrow ValidationError if doLogin throws it', () async {
        when(mockLoginRepository.doLogin(tParamsWrong))
            .thenThrow(ValidationError());

        Function call = sut;

        expect(() => call(tParamsWrong),
            throwsA(const TypeMatcher<ValidationError>()));
      });

      test('should rethrow ServerError if doLogin throws it', () async {
        when(mockLoginRepository.doLogin(tParams)).thenThrow(ServerError());

        Function call = sut;

        expect(() => call(tParams), throwsA(const TypeMatcher<ServerError>()));
      });

      test('should rethrow NetworkError if doLogin throws it', () async {
        when(mockLoginRepository.doLogin(tParams)).thenThrow(NetworkError());

        Function call = sut;

        expect(() => call(tParams), throwsA(const TypeMatcher<NetworkError>()));
      });
    });

    group("if doLogin returns a valid Session", () {
      test(
        'should call saveSession from LoginRepository passing correct parameters',
        () async {
          await sut(tParams);

          verify(mockLoginRepository.saveSession(tSession));
        },
      );

      test(
        'should rethrow StorageError if saveSession throws it',
        () async {
          when(mockLoginRepository.saveSession(tSession))
              .thenThrow(StorageError());

          final call = sut;

          expect(
              () => call(tParams), throwsA(const TypeMatcher<StorageError>()));
        },
      );

      test(
        'if typeUser of session.user is 0 (admin) should call redirect from Router with correct parameters (admin home route)',
        () async {
          when(mockLoginRepository.doLogin(tParams))
              .thenAnswer((_) async => tSessionAdmin);

          await sut(tParams);

          verify(mockRouter.redirect(Routes.homeAdmin));
        },
      );

      test(
          'if typeUser of session.user is 1 (employee) should call redirect from Router with correct parameters (employee home route)',
          () async {
        when(mockLoginRepository.doLogin(tParams))
            .thenAnswer((_) async => tSessionEmployee);

        await sut(tParams);

        verify(mockRouter.redirect(Routes.homeEmployee));
      });

      test('should return Session if operation is successful', () async {
        Session? session = await sut(tParams);

        expect(session, equals(tSession));
      });
    });
  });
}
