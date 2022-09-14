import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pomar_app/core/config/dio_config.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/features/auth/login_initializer.dart';
import 'package:pomar_app/features/employee/employee_initializer.dart';

class Initializer {
  Future<void> init() async {
    Globals.sl = GetIt.instance;
    Dio dio = DioConfig.getInstance();
    Globals.sl.registerLazySingleton(() => dio);
    await LoginInitializer(sl: Globals.sl, dio: dio).init();
    await EmployeeInitializer(sl: Globals.sl, dio: dio).init();
  }
}
