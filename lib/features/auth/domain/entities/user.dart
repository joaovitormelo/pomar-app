import 'package:equatable/equatable.dart';
import 'person.dart';

class User extends Equatable {
  final int idUser;
  final Person person;
  final String password;
  final int typeUser;

  User(
      {required this.idUser,
      required this.person,
      required this.password,
      required this.typeUser});

  @override
  List<Object?> get props => [idUser, person, password, typeUser];
}
