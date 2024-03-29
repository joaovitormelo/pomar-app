import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pomar_app/features/schedule/data/datasources/schedule_server_source.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_add_event.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_delete_event.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_edit_event.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events_by_employee.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_tasks_by_employee.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_switch_complete.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/add_event/add_event_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/delete_event/delete_event_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/edit_event/edit_event_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/read_events/read_events_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/read_today_tasks/read_today_tasks_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/switch_complete_bloc/switch_complete_bloc.dart';

class ScheduleInitializer {
  final GetIt sl;
  final Dio dio;

  ScheduleInitializer({required this.sl, required this.dio});

  Future<void> init() async {
    sl.registerFactory(
      () => ReadEventsBloc(
        authBloc: sl(),
        doReadEvents: sl(),
        doReadEventsByEmployee: sl(),
      ),
    );
    sl.registerFactory(() => AddEventBloc(authBloc: sl(), doAddEvent: sl()));
    sl.registerFactory(() => EditEventBloc(authBloc: sl(), doEditEvent: sl()));
    sl.registerFactory(
        () => DeleteEventBloc(authBloc: sl(), doDeleteEvent: sl()));
    sl.registerFactory(
        () => SwitchCompleteBloc(authBloc: sl(), doSwitchComplete: sl()));
    sl.registerFactory(
        () => ReadTodayTasksBloc(authBloc: sl(), doReadTasksByEmployee: sl()));

    sl.registerLazySingleton(() => DoReadEvents(scheduleServerSource: sl()));
    sl.registerLazySingleton(
        () => DoReadEventsByEmployee(scheduleServerSource: sl()));
    sl.registerLazySingleton(() => DoAddEvent(scheduleServerSource: sl()));
    sl.registerLazySingleton(() => DoEditEvent(scheduleServerSource: sl()));
    sl.registerLazySingleton(() => DoDeleteEvent(scheduleServerSource: sl()));
    sl.registerLazySingleton(
        () => DoSwitchComplete(scheduleServerSource: sl()));
    sl.registerLazySingleton(
        () => DoReadTasksByEmployee(scheduleServerSource: sl()));

    sl.registerLazySingleton<ScheduleServerSource>(
        () => ScheduleServerSource(dio: sl()));
  }
}
