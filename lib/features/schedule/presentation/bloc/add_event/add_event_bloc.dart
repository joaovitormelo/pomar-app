import 'package:bloc/bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_states.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_add_event.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/add_event/add_event_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/add_event/add_event_states.dart';

class AddEventBloc extends Bloc<AddEventEvents, AddEventStates> {
  final AuthBloc authBloc;
  final DoAddEvent doAddEvent;

  AddEventBloc({required this.authBloc, required this.doAddEvent})
      : super(AddEventDefault()) {
    on<AddEventButtonPressed>(onAddEventButtonPressed);
  }

  onAddEventButtonPressed(AddEventButtonPressed event, emit) async {
    Session session = (authBloc.state as AuthorizedAdmin).session;
    try {
      await doAddEvent(session.jwtToken, event.addEventParams);
    } catch (e) {
      emit(AddEventError(msg: mapErrorToMsg(e)));
    }
  }
}
