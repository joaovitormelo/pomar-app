import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';

class EmployeesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeesLoading extends EmployeesState {}

class EmployeesNoData extends EmployeesState {}

class EmployeesHasData extends EmployeesState {
  final List<Employee> employees;

  EmployeesHasData({required this.employees});
}

class EmployeesError extends EmployeesState {
  final String msg;

  EmployeesError({required this.msg});
}

class EmployeesOperationError extends EmployeesState {
  final String msg;

  EmployeesOperationError({required this.msg});
}
