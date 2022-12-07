import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';

class ReadTodayTasksEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodayTasks extends ReadTodayTasksEvents {
  final int idPerson;

  LoadTodayTasks({required this.idPerson});
}

class UpdateTodayTasks extends ReadTodayTasksEvents {
  final List<EventData> todayTasks;

  UpdateTodayTasks({required this.todayTasks});
}
