import 'dart:developer';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:pomar_app/core/presentation/pages/loading_page.dart';
import 'package:pomar_app/features/auth/presentation/pages/login_page.dart';
import 'package:pomar_app/features/employee/presentation/pages/add_employee_page.dart';
import 'package:pomar_app/features/employee/presentation/pages/edit_employee_page.dart';
import 'package:pomar_app/features/employee/presentation/pages/employees_page.dart';
import 'package:pomar_app/features/home/presentation/pages/home_admin_page.dart';
import 'package:pomar_app/features/home/presentation/pages/home_employee_page.dart';

class FluroHandlers {
  //AUTH
  static Handler loadingHandler =
      Handler(handlerFunc: (context, params) => const LoadingPage());
  static Handler loginHandler =
      Handler(handlerFunc: (context, params) => const LoginPage());
  //HOME
  static Handler homeAdminHandler =
      Handler(handlerFunc: (context, params) => const HomeAdmin());
  static Handler homeEmployeeHandler =
      Handler(handlerFunc: (context, params) => const HomeEmployee());
  //EMPLOYEE
  static Handler employeesHandler =
      Handler(handlerFunc: (context, params) => const EmployeesPage());
  static Handler addEmployeeHandler =
      Handler(handlerFunc: (context, params) => const AddEmployeePage());
  static Handler editEmployeeHandler = Handler(
    handlerFunc: (context, params) {
      final dynamic args =
          ModalRoute.of(context as BuildContext)?.settings.arguments;
      return EditEmployeePage(employee: args);
    },
  );
}
