import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';

import 'user_model.dart';

class SessionModel extends Session with EquatableMixin {
  @override
  final UserModel user;

  SessionModel(
      {required super.idSession,
      required this.user,
      required super.jwtToken,
      required super.loginTime})
      : super(user: user);

  factory SessionModel.fromEntity(Session session) {
    return SessionModel(
      idSession: session.idSession,
      user: UserModel.fromEntity(session.user),
      jwtToken: session.jwtToken,
      loginTime: session.loginTime,
    );
  }

  factory SessionModel.fromJSON(Map<String, dynamic> sessionJSON) {
    return SessionModel(
      idSession: sessionJSON['id_session'],
      user: UserModel.fromJSON(sessionJSON['user']),
      jwtToken: sessionJSON['jwt_token'],
      loginTime: sessionJSON['login_time'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id_session": idSession,
      "user": user.toJSON(),
      "jwt_token": jwtToken,
      "login_time": loginTime,
    };
  }
}
