import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';

class ReadTodayTasksStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReadTodayTasksNoData extends ReadTodayTasksStates {}

class ReadTodayTasksLoading extends ReadTodayTasksStates {}

class ReadTodayTasksHasData extends ReadTodayTasksStates {
  final List<EventData> eventDList;

  ReadTodayTasksHasData({required this.eventDList});
}

class ReadTodayTasksError extends ReadTodayTasksStates {
  final String msg;

  ReadTodayTasksError({required this.msg});
}
