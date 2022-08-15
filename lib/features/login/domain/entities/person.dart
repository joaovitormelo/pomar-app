import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final int idPerson;
  final String name;
  final String email;
  final String phone;

  Person(
      {required this.idPerson,
      required this.name,
      required this.email,
      required this.phone});

  @override
  List<Object?> get props => [idPerson, name, email, phone];
}
