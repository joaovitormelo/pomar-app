import 'dart:developer';

import 'package:pomar_app/core/config/constants.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/data/models/person_model.dart';
import 'package:pomar_app/features/auth/data/models/session_model.dart';
import 'package:pomar_app/features/auth/data/models/user_model.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

abstract class ServerSourceContract {
  Future<SessionModel>? doLogin(LoginParams params);
  Future<void> logout(int idSession);
  Future<void> validateSession(SessionModel session);
}

class ServerSource implements ServerSourceContract {
  @override
  Future<SessionModel>? doLogin(LoginParams params) async {
    var url = Uri.http(Constants.serverUrl, "login");
    var body = {"email": params.email, "password": params.password};
    var response;
    try {
      response = await http.post(url, body: body);
    } catch (e) {
      throw ConnectionError();
    }
    var responseData = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      return SessionModel.fromJSON(responseData["session"]);
    } else {
      throw mapServerResponseToError(response.statusCode, responseData);
    }
  }

  @override
  Future<void> logout(int idSession) async {
    var url = Uri.http(Constants.serverUrl, "logout");
    var body = {"id_session": idSession.toString()};
    var response;
    try {
      response = await http.post(url, body: body);
    } catch (e) {
      throw ConnectionError();
    }
    var responseData =
        response.body != "" ? convert.jsonDecode(response.body) : {};
    if (response.statusCode != 200) {
      throw mapServerResponseToError(response.statusCode, responseData);
    }
  }

  @override
  Future<void> validateSession(SessionModel session) async {
    var url = Uri.http(Constants.serverUrl, "validateSession");
    var body = {"session": convert.jsonEncode(session.toJSON())};
    var response;
    try {
      response = await http.post(url, body: body);
    } catch (e) {
      inspect(e);
      throw ConnectionError();
    }
    var responseData =
        response.body != "" ? convert.jsonDecode(response.body) : {};
    if (response.statusCode != 200) {
      throw mapServerResponseToError(response.statusCode, responseData);
    }
  }
}
