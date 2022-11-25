import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';

class ReadEventsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEvents extends ReadEventsEvent {}

class LoadEventsByEmployee extends ReadEventsEvent {
  final int idPerson;

  LoadEventsByEmployee({required this.idPerson});
}

class UpdateEventList extends ReadEventsEvent {
  final List<EventData> eventDList;

  UpdateEventList({required this.eventDList});
}
