import 'package:flutter_test/flutter_test.dart';

main() {
  test("Test", () {});
}

/*import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:pomar_app/core/config/constants.dart';
import 'package:pomar_app/core/config/server_routes.dart';
import 'package:pomar_app/features/auth/data/datasources/server_source.dart';
import 'package:pomar_app/features/auth/data/models/person_model.dart';
import 'package:pomar_app/features/auth/data/models/session_model.dart';
import 'package:pomar_app/features/auth/data/models/user_model.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockClient extends Mock implements http.Client {}

class ServerSource implements ServerSourceContract {
  final http.Client client;

  ServerSource({required this.client});

  @override
  Future<SessionModel?>? doLogin(LoginParams params) async {
    await client
        .post(Uri.https(Constants.serverUrl, ServerRoutes.login), body: {
      "email": params.email,
      "password": params.password,
    });
  }
}

main() {
  group("Test ServerSource", () {
    group("doLogin", () {
      Uri tUri = Uri.https(Constants.serverUrl, ServerRoutes.login);
      LoginParams tParams = LoginParams(email: "email", password: "password");
      UserModel tUser = UserModel(
        idUser: 1,
        person: PersonModel(
          idPerson: 1,
          name: "name",
          email: "email",
          phone: "phone",
        ),
        password: "password",
        typeUser: 0,
      );
      Map tBody = {
        "email": tParams.email,
        "password": tParams.password,
      };
      SessionModel tSession =
          SessionModel.fromJSON(json.decode(fixture("session.json")));
      http.Response tResponse = http.Response(fixture("session.json"), 200);
      late MockClient mockClient;
      late ServerSource sut;

      setUp(() {
        mockClient = MockClient();
        when(mockClient.post(tUri, body: tBody))
            .thenAnswer((_) async => tResponse);
        sut = ServerSource(client: mockClient);
      });

      test(
        "it should call post from Client with correct parameters",
        () async {
          await sut.doLogin(tParams);

          verify(mockClient.post(tUri, body: tBody));
        },
      );

      group("If error", () {
        test("if post throws should throw ConnectionError", () {});

        test(
          "if post returns response with status 400 and code 001 should throw ServerError",
          () {},
        );

        test(
          "if post returns response with status 400 and code 002 should throw ServerError",
          () {},
        );

        test(
          "if post returns response with status 400 and code 003 should throw ValidationError with correct value",
          () {},
        );

        test(
          "if post returns response with status 503 and code 001 should throw ConnectionError",
          () {},
        );

        test(
          "if post returns response with status 404 and code 002 should throw UserNotFoundError",
          () {},
        );

        test(
          "if post returns response with status 401 and code 001 should throw AuthenticationError",
          () {},
        );

        test(
          "if post returns response with status 500 should throw ServerError",
          () {},
        );

        test("should throw EmptyResponse error if response body is empty",
            () {});
      });

      test("should return correct Session", () {});
    });
  });
}*/
