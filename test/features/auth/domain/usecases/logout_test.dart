import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/domain/usecases/logout.dart';
import 'do_login_test.dart';

main() {
  group("Test Logout Usecase", () {
    int tIdSession = 0;
    late MockLoginRepository mockLoginRepository;
    late Logout sut;

    setUp(() {
      mockLoginRepository = MockLoginRepository();
      sut = Logout(loginRepository: mockLoginRepository);
    });

    test("It should call logout from loginRepository with correct parameters",
        () async {
      await sut(tIdSession);

      verify(mockLoginRepository.logout(tIdSession));
    });

    group("If logout throws", () {
      test("It should rethrow ConnectionError", () {
        when(mockLoginRepository.logout(tIdSession))
            .thenThrow(ConnectionError());

        var call = sut;

        expect(() => call(tIdSession),
            throwsA(const TypeMatcher<ConnectionError>()));
      });

      test("It should rethrow ServerError", () {
        when(mockLoginRepository.logout(tIdSession)).thenThrow(ServerError());

        var call = sut;

        expect(
            () => call(tIdSession), throwsA(const TypeMatcher<ServerError>()));
      });

      test("It should rethrow NetworkError", () {
        when(mockLoginRepository.logout(tIdSession)).thenThrow(NetworkError());

        var call = sut;

        expect(
            () => call(tIdSession), throwsA(const TypeMatcher<NetworkError>()));
      });
    });
  });
}
