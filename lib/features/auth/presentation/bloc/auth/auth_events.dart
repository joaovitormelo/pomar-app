import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppInitialized extends AuthEvent {}

class DidLogin extends AuthEvent {
  final Session session;

  DidLogin({required this.session});
}

class LogoutEvent extends AuthEvent {
  final int idSession;

  LogoutEvent({required this.idSession});
}
