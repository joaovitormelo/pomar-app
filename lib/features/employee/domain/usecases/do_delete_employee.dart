import 'package:pomar_app/features/employee/data/repositories/employee_repository.dart';

class DoDeleteEmployee {
  final EmployeeRepositoryContract employeeRepository;

  DoDeleteEmployee({required this.employeeRepository});

  call(String token, int idEmployee) async {
    await employeeRepository.deleteEmployee(token, idEmployee);
  }
}
