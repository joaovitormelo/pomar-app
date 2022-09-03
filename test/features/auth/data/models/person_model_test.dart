import 'package:flutter_test/flutter_test.dart';
import 'package:pomar_app/features/auth/data/models/person_model.dart';
import 'package:pomar_app/features/auth/domain/entities/person.dart';

main() {
  group("Test PersonModel", () {
    PersonModel tPersonModel =
        PersonModel(idPerson: 1, name: "name", email: "email", phone: "phone");

    Map<String, dynamic> tJSON = {
      "idPerson": 1,
      "name": "name",
      "email": "email",
      "phone": "phone",
    };

    group("fromEntity", () {
      Person tPerson =
          Person(idPerson: 1, name: "name", email: "email", phone: "phone");

      test("it should return correct personModel", () {
        final converted = PersonModel.fromEntity(tPerson);

        expect(converted, equals(tPersonModel));
      });
    });

    group("fromJSON", () {
      test("it should return correct personModel", () {
        final converted = PersonModel.fromJSON(tJSON);

        expect(converted, equals(tPersonModel));
      });
    });

    group("toJSON", () {
      test("it should return correct JSON", () {
        final converted = tPersonModel.toJSON();

        expect(converted, equals(tJSON));
      });
    });
  });
}
