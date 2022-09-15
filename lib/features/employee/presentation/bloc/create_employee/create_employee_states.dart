import 'package:equatable/equatable.dart';

class CreateEmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateEmployeeDefault extends CreateEmployeeState {}

class CreateEmployeeLoading extends CreateEmployeeState {}

class CreateEmployeeSuccess extends CreateEmployeeState {}

class CreateEmployeeError extends CreateEmployeeState {
  final String message;

  CreateEmployeeError({required this.message});
}
