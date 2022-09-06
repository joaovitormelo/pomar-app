import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginDefault extends LoginState {}

class Logging extends LoginState {}

class LoginError extends LoginState {
  final String message;

  LoginError({required this.message});
}
