import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';

class ReadEventsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReadEventsNoData extends ReadEventsState {}

class ReadEventsLoading extends ReadEventsState {}

class ReadEventsHasData extends ReadEventsState {
  final List<EventData> eventList;

  ReadEventsHasData({required this.eventList});
}

class ReadEventsError extends ReadEventsState {
  final String msg;

  ReadEventsError({required this.msg});
}
