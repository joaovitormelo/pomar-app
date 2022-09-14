import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/features/employee/data/datasources/employee_server_source.dart';
import 'package:pomar_app/features/employee/data/repositories/employee_repository.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_create_employee.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_read_employees.dart';
import 'package:pomar_app/features/employee/presentation/bloc/bloc.dart';

class EmployeeInitializer {
  final GetIt sl;
  final Dio dio;

  EmployeeInitializer({required this.sl, required this.dio});

  Future<void> init() async {
    sl.registerFactory(
        () => EmployeesBloc(authBloc: sl(), doReadEmployees: sl()));

    sl.registerLazySingleton(() => DoReadEmployees(employeesRepository: sl()));
    sl.registerLazySingleton(() => DoCreateEmployee(employeeRepository: sl()));

    sl.registerLazySingleton<EmployeeRepositoryContract>(
        () => EmployeeRepository(employeeServerSourceContract: sl()));

    sl.registerLazySingleton<EmployeeServerSourceContract>(
        () => EmployeeServerSource(dio: sl()));
  }
}
