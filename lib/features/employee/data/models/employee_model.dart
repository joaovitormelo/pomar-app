import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/auth/data/models/person_model.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';

class EmployeeModel extends Employee with EquatableMixin {
  @override
  List<Object?> get props => [idEmployee, person];

  @override
  final PersonModel person;

  EmployeeModel({required super.idEmployee, required this.person})
      : super(person: person);

  factory EmployeeModel.fromEntity(Employee employee) {
    return EmployeeModel(
      idEmployee: employee.idEmployee,
      person: PersonModel.fromEntity(employee.person),
    );
  }

  factory EmployeeModel.fromJSON(Map<String, dynamic> employeeJSON) {
    return EmployeeModel(
      idEmployee: employeeJSON['id_employee'],
      person: PersonModel.fromJSON(employeeJSON['person']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id_employee": idEmployee,
      "person": person.toJSON(),
    };
  }
}
