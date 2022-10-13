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
import 'package:pomar_app/features/schedule/presentation/pages/add_event_page.dart';
import 'package:pomar_app/features/schedule/presentation/pages/edit_event_page.dart';
import 'package:pomar_app/features/schedule/presentation/pages/schedule_admin_page.dart';

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
  //SCHEDULE
  static Handler scheduleAdminHandler =
      Handler(handlerFunc: (context, params) => const ScheduleAdminPage());
  static Handler addEventHandler = Handler(
    handlerFunc: (context, params) {
      final dynamic args =
          ModalRoute.of(context as BuildContext)?.settings.arguments;
      return AddEventPage(employeeList: args);
    },
  );
  static Handler editEventHandler = Handler(
    handlerFunc: (context, params) {
      final dynamic args =
          ModalRoute.of(context as BuildContext)?.settings.arguments;
      return EditEventPage(
        employeeList: args[0],
        eventD: args[1],
      );
    },
  );
}
