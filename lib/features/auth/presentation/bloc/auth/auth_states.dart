import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Unitialized extends AuthState {}

class Unauthorized extends AuthState {}

class Loading extends AuthState {}

class AuthorizedAdmin extends AuthState {
  final Session session;

  AuthorizedAdmin({required this.session});
}

class AuthorizedEmployee extends AuthState {
  final Session session;

  AuthorizedEmployee({required this.session});
}
