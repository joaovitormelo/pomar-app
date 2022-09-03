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
    } else if (response.statusCode == 404 && responseData["code"] == "002") {
      throw UserNotFoundError();
    } else if (response.statusCode == 401 && responseData["code"] == "001") {
      throw UnauthorizedError();
    } else if (response.statusCode == 400) {
      throw ValidationError();
    } else if (response.statusCode == 503 && responseData["code"] == "001") {
      throw ConnectionError();
    } else {
      throw ServerError();
    }
  }
}
