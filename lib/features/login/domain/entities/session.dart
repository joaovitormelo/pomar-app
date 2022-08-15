import 'package:equatable/equatable.dart';
import 'user.dart';

class Session extends Equatable {
  final int idSession;
  final User user;
  final String jwtToken;
  final String loginTime;

  Session(
      {required this.idSession,
      required this.user,
      required this.jwtToken,
      required this.loginTime});

  @override
  List<Object?> get props => [idSession, user, jwtToken, loginTime];
}
