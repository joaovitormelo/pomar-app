import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_states.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events_by_employee.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/read_events/read_events_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/read_events/read_events_states.dart';
import 'package:pomar_app/core/errors/error_messages.dart';

class ReadEventsBloc extends Bloc<ReadEventsEvent, ReadEventsState> {
  final AuthBloc authBloc;
  final DoReadEvents doReadEvents;
  final DoReadEventsByEmployee doReadEventsByEmployee;

  ReadEventsBloc(
      {required this.authBloc,
      required this.doReadEvents,
      required this.doReadEventsByEmployee})
      : super(ReadEventsNoData()) {
    on<LoadEvents>(onLoadEvents);
    on<LoadEventsByEmployee>(onLoadEventsByEmployee);
    on<UpdateEventList>(onUpdateEventList);
  }

  onLoadEvents(LoadEvents event, Emitter<ReadEventsState> emit) async {
    Session session = (authBloc.state as AuthorizedAdmin).session;
    emit(ReadEventsLoading());
    try {
      List<EventData> eventList = await doReadEvents(session.jwtToken);
      emit(ReadEventsHasData(eventList: eventList));
    } catch (e) {
      inspect(e);
      if (e is NoDataError) emit(ReadEventsNoData());
      emit(ReadEventsError(msg: mapErrorToMsg(e)));
    }
  }

  onLoadEventsByEmployee(
      LoadEventsByEmployee event, Emitter<ReadEventsState> emit) async {
    Session session = (authBloc.state as AuthorizedEmployee).session;
    emit(ReadEventsLoading());
    try {
      List<EventData> eventList =
          await doReadEventsByEmployee(session.jwtToken, event.idPerson);
      emit(ReadEventsHasData(eventList: eventList));
    } catch (e) {
      inspect(e);
      if (e is NoDataError) emit(ReadEventsNoData());
      emit(ReadEventsError(msg: mapErrorToMsg(e)));
    }
  }

  onUpdateEventList(
      UpdateEventList event, Emitter<ReadEventsState> emit) async {
    emit(ReadEventsNoData());
    emit(ReadEventsHasData(eventList: event.eventDList));
  }
}
