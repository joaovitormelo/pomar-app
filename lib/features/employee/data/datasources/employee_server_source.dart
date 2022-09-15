import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pomar_app/core/config/server_routes.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/data/models/user_model.dart';
import 'package:pomar_app/features/employee/data/models/employee_model.dart';

abstract class EmployeeServerSourceContract {
  Future<List<EmployeeModel>> readEmployees(String token);
  Future<void> createEmployee(
      String token, EmployeeModel employee, UserModel user);
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

  @override
  Future<void> createEmployee(
      String token, EmployeeModel employee, UserModel user) async {
    Options options = Options(
      method: ServerRoutes.createEmployee.method,
      headers: {
        "Authorization": token,
      },
    );
    Map<String, dynamic> data = {
      "employee": employee.toJSON(),
      "user": user.toJSON(),
    };
    Response response;
    try {
      response = await dio.request(
        ServerRoutes.createEmployee.path,
        options: options,
        data: data,
      );
    } catch (e) {
      print(e);
      inspect(e);
      throw ConnectionError();
    }
    if (response.statusCode != 200) {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }
}
