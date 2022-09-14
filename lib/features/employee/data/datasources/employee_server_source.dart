import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pomar_app/core/config/server_routes.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/employee/data/models/employee_model.dart';

abstract class EmployeeServerSourceContract {
  Future<List<EmployeeModel>> readEmployees(String token);
}

class EmployeeServerSource implements EmployeeServerSourceContract {
  final Dio dio;

  EmployeeServerSource({required this.dio});

  @override
  Future<List<EmployeeModel>> readEmployees(String token) async {
    Options options = Options(
      method: ServerRoutes.readEmployees.method,
      headers: {
        "Authorization": token,
      },
    );
    Response response;
    try {
      response = await dio.request(
        ServerRoutes.readEmployees.path,
        options: options,
      );
    } catch (e) {
      throw ConnectionError();
    }
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((employee) => EmployeeModel.fromJSON(employee))
          .toList();
    } else {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }
}
