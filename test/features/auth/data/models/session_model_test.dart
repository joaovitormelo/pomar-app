import 'package:flutter_test/flutter_test.dart';
import 'package:pomar_app/features/auth/data/models/session_model.dart';
import 'package:pomar_app/features/auth/data/models/user_model.dart';
import 'package:pomar_app/features/auth/domain/entities/person.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/domain/entities/user.dart';

main() {
  group("Test SessionModel", () {
    User tUser = User(
      idUser: 1,
      person: Person(idPerson: 1, name: "name", email: "email", phone: "phone"),
      password: "password",
      typeUser: 0,
    );
    UserModel tUserModel = UserModel.fromEntity(tUser);
    Session tSession = Session(
      idSession: 1,
      user: tUser,
      jwtToken: "jwtToken",
      loginTime: "loginTime",
    );
    SessionModel tSessionModel = SessionModel(
      idSession: 1,
      user: tUserModel,
      jwtToken: "jwtToken",
      loginTime: "loginTime",
    );
    Map<String, dynamic> tJSON = {
      "idSession": 1,
      "user": tUserModel.toJSON(),
      "jwtToken": "jwtToken",
      "loginTime": "loginTime",
    };

    test("fromEntity should return correct SessionModel", () {
      final received = SessionModel.fromEntity(tSession);

      expect(received, tSessionModel);
    });

    test("fromJSON should return correct SessionModel", () {
      final received = SessionModel.fromJSON(tJSON);

      expect(received, tSessionModel);
    });

    test("toJSON should return correct JSON", () {
      final received = tSessionModel.toJSON();

      expect(received, equals(tJSON));
    });
  });
}
