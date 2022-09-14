import 'package:pomar_app/features/employee/data/repositories/employee_repository.dart';

class DoReadEmployees {
  final EmployeeRepositoryContract employeesRepository;

  DoReadEmployees({required this.employeesRepository});

  call(String token) async {
    return await employeesRepository.readEmployees(token);
  }
}
