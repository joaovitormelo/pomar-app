import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_states.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_delete_event.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/delete_event/delete_event_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/delete_event/delete_event_states.dart';
import 'package:pomar_app/core/errors/error_messages.dart';

class DeleteEventBloc extends Bloc<DeleteEventEvent, DeleteEventState> {
  final AuthBloc authBloc;
  final DoDeleteEvent doDeleteEvent;

  DeleteEventBloc({required this.authBloc, required this.doDeleteEvent})
      : super(DeleteEventDefault()) {
    on<DeleteEventButtonPressed>(onDeleteEventButtonPressed);
  }

  onDeleteEventButtonPressed(
      DeleteEventButtonPressed event, Emitter<DeleteEventState> emit) async {
    Session session = (authBloc.state as AuthorizedAdmin).session;
    emit(DeleteEventLoading());
    try {
      await doDeleteEvent(session.jwtToken, event.params);
      emit(DeleteEventSuccess());
    } catch (e) {
      inspect(e);
      emit(DeleteEventError(msg: mapErrorToMsg(e)));
    }
  }
}
