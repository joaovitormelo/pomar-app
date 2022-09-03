import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/auth/domain/entities/user.dart';
import 'person_model.dart';

class UserModel extends User with EquatableMixin {
  @override
  final PersonModel person;

  UserModel(
      {required super.idUser,
      required this.person,
      required super.password,
      required super.typeUser})
      : super(person: person);

  factory UserModel.fromEntity(User user) {
    return UserModel(
        idUser: 1,
        person: PersonModel.fromEntity(user.person),
        password: user.password,
        typeUser: user.typeUser);
  }

  factory UserModel.fromJSON(Map<String, dynamic> userJSON) {
    return UserModel(
        idUser: userJSON["id_user"],
        person: PersonModel.fromJSON(userJSON["person"]),
        password: userJSON["password"],
        typeUser: userJSON["type_user"]);
  }

  Map<String, dynamic> toJSON() {
    return {
      "id_user": idUser,
      "person": person.toJSON(),
      "password": password,
      "type_user": typeUser,
    };
  }
}
