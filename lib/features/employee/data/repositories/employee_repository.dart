import 'package:pomar_app/features/auth/domain/entities/user.dart';
import 'package:pomar_app/features/employee/data/datasources/employee_server_source.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';

abstract class EmployeeRepositoryContract {
  Future<List<Employee>> readEmployees(String token);
  Future<void> createEmployee(String token, Employee employee, User user);
}

class EmployeeRepository implements EmployeeRepositoryContract {
  final EmployeeServerSourceContract employeeServerSourceContract;

  EmployeeRepository({required this.employeeServerSourceContract});

  @override
  Future<List<Employee>> readEmployees(String token) async {
    return await employeeServerSourceContract.readEmployees(token);
  }

  @override
  Future<void> createEmployee(
      String token, Employee employee, User user) async {}
}
