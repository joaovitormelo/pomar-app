import 'package:equatable/equatable.dart';

class EmployeesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEmployees extends EmployeesEvent {}

class DeleteEmployeeBlocEmmitedLoading extends EmployeesEvent {}

class DeleteEmployeeBlocEmmitedSuccess extends EmployeesEvent {}

class DeleteEmployeeBlocEmmitedError extends EmployeesEvent {
  final String msg;

  DeleteEmployeeBlocEmmitedError({required this.msg});
}
