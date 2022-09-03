import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DoLoginEvent extends LoginEvent {
  final String email;
  final String password;
  DoLoginEvent({required this.email, required this.password});
}
