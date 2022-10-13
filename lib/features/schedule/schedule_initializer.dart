import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/features/employee/data/datasources/employee_server_source.dart';
import 'package:pomar_app/features/employee/data/repositories/employee_repository.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_create_employee.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_delete_employee.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_read_employees.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_update_employee.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:pomar_app/features/schedule/data/datasources/schedule_server_source.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_add_event.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_edit_event.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/add_event/add_event_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/edit_event/edit_event_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/read_events/read_events_bloc.dart';

class ScheduleInitializer {
  final GetIt sl;
  final Dio dio;

  ScheduleInitializer({required this.sl, required this.dio});

  Future<void> init() async {
    sl.registerFactory(
        () => ReadEventsBloc(authBloc: sl(), doReadEvents: sl()));
    sl.registerFactory(() => AddEventBloc(authBloc: sl(), doAddEvent: sl()));
    sl.registerFactory(() => EditEventBloc(authBloc: sl(), doEditEvent: sl()));

    sl.registerLazySingleton(() => DoReadEvents(scheduleServerSource: sl()));
    sl.registerLazySingleton(() => DoAddEvent(scheduleServerSource: sl()));
    sl.registerLazySingleton(() => DoEditEvent(scheduleServerSource: sl()));

    sl.registerLazySingleton<ScheduleServerSource>(
        () => ScheduleServerSource(dio: sl()));
  }
}
