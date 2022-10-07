import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/auth/domain/entities/person.dart';

class Employee extends Equatable {
  int idEmployee;
  Person person;

  Employee({required this.idEmployee, required this.person});

  @override
  List<Object?> get props => [idEmployee];
}
