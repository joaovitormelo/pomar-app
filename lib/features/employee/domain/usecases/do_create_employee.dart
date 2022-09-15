import 'package:pomar_app/features/auth/domain/entities/person.dart';
import 'package:pomar_app/features/auth/domain/entities/user.dart';
import 'package:pomar_app/features/employee/data/repositories/employee_repository.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';

class CreateEmployeeParams {
  final String name;
  final String email;
  final String phone;
  final String password;

  CreateEmployeeParams(
      {required this.name,
      required this.email,
      required this.phone,
      required this.password});
}

class DoCreateEmployee {
  EmployeeRepositoryContract employeeRepository;

  DoCreateEmployee({required this.employeeRepository});

  call(String token, CreateEmployeeParams employeeParams) async {
    Person person = Person(
      idPerson: 0,
      name: employeeParams.name,
      email: employeeParams.email,
      phone: employeeParams.phone,
    );
    Employee employee = Employee(idEmployee: 0, person: person);
    User user = User(
        idUser: 0,
        person: person,
        password: employeeParams.password,
        typeUser: 1);
    await employeeRepository.createEmployee(token, employee, user);
  }
}
