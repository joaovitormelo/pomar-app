import 'package:flutter_test/flutter_test.dart';
import 'package:pomar_app/features/login/data/models/person_model.dart';
import 'package:pomar_app/features/login/data/models/user_model.dart';
import 'package:pomar_app/features/login/domain/entities/person.dart';
import 'package:pomar_app/features/login/domain/entities/user.dart';

main() {
  group("Test UserModel", () {
    Person tPerson =
        Person(idPerson: 1, name: "name", email: "email", phone: "phone");
    PersonModel tPersonModel = PersonModel.fromEntity(tPerson);
    User tUser = User(
      idUser: 1,
      person: tPerson,
      password: "password",
      typeUser: 0,
    );
    UserModel tUserModel = UserModel(
      idUser: 1,
      person: tPersonModel,
      password: "password",
      typeUser: 0,
    );
    Map<String, dynamic> tJSON = {
      "idUser": 1,
      "person": tPersonModel.toJSON(),
      "password": "password",
      "typeUser": 0,
    };

    test("fromEntity should return correct UserModel", () {
      final received = UserModel.fromEntity(tUser);

      expect(received, equals(tUserModel));
    });

    test("fromJSON should return correct UserModel", () {
      final received = UserModel.fromJSON(tJSON);

      expect(received, equals(tUserModel));
    });

    test("toJSON should return correct JSON", () {
      final received = tUserModel.toJSON();

      expect(received, equals(tJSON));
    });
  });
}
