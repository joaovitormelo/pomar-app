import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/data/models/user_model.dart';
import 'package:pomar_app/features/auth/domain/entities/user.dart';
import 'package:pomar_app/features/employee/data/datasources/employee_server_source.dart';
import 'package:pomar_app/features/employee/data/models/employee_model.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_update_employee.dart';

abstract class EmployeeRepositoryContract {
  Future<List<Employee>> readEmployees(String token);
  Future<void> createEmployee(String token, Employee employee, User user);
  Future<void> updateEmployee(String token, UpdateEmployeeParams params);
  Future<void> deleteEmployee(String token, int idEmployee);
}

class EmployeeRepository implements EmployeeRepositoryContract {
  final EmployeeServerSourceContract employeeServerSource;

  EmployeeRepository({required this.employeeServerSource});

  @override
  Future<List<Employee>> readEmployees(String token) async {
    return await employeeServerSource.readEmployees(token);
  }

  @override
  Future<void> createEmployee(
      String token, Employee employee, User user) async {
    return await employeeServerSource.createEmployee(
        token, EmployeeModel.fromEntity(employee), UserModel.fromEntity(user));
  }

  @override
  Future<void> updateEmployee(String token, UpdateEmployeeParams params) async {
    await employeeServerSource.updateEmployee(token, params);
  }

  @override
  Future<void> deleteEmployee(String token, int idEmployee) async {
    await employeeServerSource.deleteEmployee(token, idEmployee);
  }
}
