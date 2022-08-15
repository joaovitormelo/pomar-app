import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/login/domain/entities/session.dart';

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
      idSession: sessionJSON['idSession'],
      user: UserModel.fromJSON(sessionJSON['user']),
      jwtToken: sessionJSON['jwtToken'],
      loginTime: sessionJSON['loginTime'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "idSession": idSession,
      "user": user.toJSON(),
      "jwtToken": jwtToken,
      "loginTime": loginTime,
    };
  }
}
