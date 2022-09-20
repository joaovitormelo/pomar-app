import 'package:equatable/equatable.dart';

class UpdateEmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateEmployeeDefault extends UpdateEmployeeState {}

class UpdateEmployeeLoading extends UpdateEmployeeState {}

class UpdateEmployeeSuccess extends UpdateEmployeeState {}

class UpdateEmployeeError extends UpdateEmployeeState {
  final String message;

  UpdateEmployeeError({required this.message});
}
