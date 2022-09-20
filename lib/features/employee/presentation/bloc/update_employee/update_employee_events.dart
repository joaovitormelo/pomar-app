import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_update_employee.dart';

class UpdateEmployeeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateEmployeeButtonPressed extends UpdateEmployeeEvent {
  final UpdateEmployeeParams params;

  UpdateEmployeeButtonPressed({required this.params});
}
