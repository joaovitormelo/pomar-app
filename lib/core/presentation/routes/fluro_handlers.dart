import 'package:fluro/fluro.dart';
import 'package:pomar_app/core/presentation/pages/loading_page.dart';
import 'package:pomar_app/features/auth/presentation/pages/login_page.dart';
import 'package:pomar_app/features/employee/presentation/pages/add_employee_page.dart';
import 'package:pomar_app/features/employee/presentation/pages/employees_page.dart';
import 'package:pomar_app/features/home/presentation/pages/home_admin_page.dart';
import 'package:pomar_app/features/home/presentation/pages/home_employee_page.dart';

class FluroHandlers {
  static Handler loadingHandler =
      Handler(handlerFunc: (context, params) => const LoadingPage());
  static Handler loginHandler =
      Handler(handlerFunc: (context, params) => const LoginPage());
  static Handler homeAdminHandler =
      Handler(handlerFunc: (context, params) => const HomeAdmin());
  static Handler homeEmployeeHandler =
      Handler(handlerFunc: (context, params) => const HomeEmployee());
  static Handler employeesHandler =
      Handler(handlerFunc: (context, params) => const EmployeesPage());
  static Handler addEmployeeHandler =
      Handler(handlerFunc: (context, params) => const AddEmployeePage());
}
