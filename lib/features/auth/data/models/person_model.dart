import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/auth/domain/entities/person.dart';

class PersonModel extends Person with EquatableMixin {
  PersonModel(
      {required super.idPerson,
      required super.name,
      required super.email,
      required super.phone});

  factory PersonModel.fromEntity(Person person) {
    return PersonModel(
        idPerson: person.idPerson,
        name: person.name,
        email: person.email,
        phone: person.phone);
  }

  factory PersonModel.fromJSON(Map<String, dynamic> personJSON) {
    return PersonModel(
        idPerson: personJSON["id_person"],
        name: personJSON["name"],
        email: personJSON["email"],
        phone: personJSON["phone"]);
  }

  Map<String, dynamic> toJSON() {
    return {
      "id_person": idPerson,
      "name": name,
      "email": email,
      "phone": phone,
    };
  }
}
