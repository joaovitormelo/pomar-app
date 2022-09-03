import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Default extends LoginState {}

class Logging extends LoginState {}

class Error extends LoginState {
  final String message;

  Error({required this.message});
}
