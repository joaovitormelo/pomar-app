import 'package:equatable/equatable.dart';

abstract class LogoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogoutDefault extends LogoutState {}

class Unlogging extends LogoutState {}

class LogoutError extends LogoutState {
  final String message;

  LogoutError({required this.message});
}
