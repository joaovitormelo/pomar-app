import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_create_employee.dart';

class CreateEmployeeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateEmployeeButtonPressed extends CreateEmployeeEvent {
  final CreateEmployeeParams createEmployeeParams;

  CreateEmployeeButtonPressed({required this.createEmployeeParams});
}
