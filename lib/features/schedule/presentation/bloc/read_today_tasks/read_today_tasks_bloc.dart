import 'package:bloc/bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_states.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_tasks_by_employee.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/read_today_tasks/read_today_tasks_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/read_today_tasks/read_today_tasks_states.dart';

class ReadTodayTasksBloc
    extends Bloc<ReadTodayTasksEvents, ReadTodayTasksStates> {
  final AuthBloc authBloc;
  final DoReadTasksByEmployee doReadTasksByEmployee;

  ReadTodayTasksBloc(
      {required this.authBloc, required this.doReadTasksByEmployee})
      : super(ReadTodayTasksNoData()) {
    on<LoadTodayTasks>(onLoadTodayTasks);
    on<UpdateTodayTasks>(onUpdateTodayTasks);
  }

  onLoadTodayTasks(LoadTodayTasks event, emit) async {
    Session session = (authBloc.state as AuthorizedEmployee).session;
    emit(ReadTodayTasksLoading());
    try {
      List<EventData> eventDList =
          await doReadTasksByEmployee(session.jwtToken, event.idPerson);
      emit(ReadTodayTasksHasData(eventDList: eventDList));
    } catch (e) {
      if (e is NoDataError) {
        emit(ReadTodayTasksNoData());
      } else {
        emit(ReadTodayTasksError(msg: mapErrorToMsg(e)));
      }
    }
  }

  onUpdateTodayTasks(UpdateTodayTasks event, emit) async {
    emit(ReadTodayTasksNoData());
    emit(ReadTodayTasksHasData(eventDList: event.todayTasks));
  }
}
