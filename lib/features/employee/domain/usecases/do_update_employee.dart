import 'dart:developer';

import 'package:pomar_app/features/auth/domain/entities/person.dart';
import 'package:pomar_app/features/employee/data/repositories/employee_repository.dart';

class UpdateEmployeeParams {
  final Person person;

  UpdateEmployeeParams({required this.person});
}

class DoUpdateEmployee {
  final EmployeeRepositoryContract employeeRepository;

  DoUpdateEmployee({required this.employeeRepository});

  call(String token, UpdateEmployeeParams params) async {
    await employeeRepository.updateEmployee(token, params);
  }
}
