import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pomar_app/core/config/constants.dart';
import 'package:pomar_app/core/config/server_routes.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/data/models/session_model.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login.dart';
import 'dart:convert' as convert;

abstract class ServerSourceContract {
  Future<SessionModel>? doLogin(LoginParams params);
  Future<void> logout(int idSession);
}

class ServerSource implements ServerSourceContract {
  Dio dio;

  ServerSource({required this.dio});

  @override
  Future<SessionModel>? doLogin(LoginParams params) async {
    Options options = Options(method: ServerRoutes.login.method);
    Map<String, dynamic> data = {
      "email": params.email,
      "password": params.password
    };
    Response response;
    try {
      response = await dio.request(
        ServerRoutes.login.path,
        options: options,
        data: data,
      );
    } catch (e) {
      throw ConnectionError();
    }
    if (response.statusCode == 200) {
      return SessionModel.fromJSON(response.data["session"]);
    } else {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }

  @override
  Future<void> logout(int idSession) async {
    Options options = Options(method: ServerRoutes.logout.method);
    Map<String, dynamic> data = {"id_session": idSession.toString()};
    Response response;
    try {
      response = await dio.request(
        ServerRoutes.logout.path,
        options: options,
        data: data,
      );
    } catch (e) {
      throw ConnectionError();
    }
    if (response.statusCode != 200) {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }
}
