import 'package:bloc/bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_edit_event.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/edit_event/edit_event_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/edit_event/edit_event_states.dart';

class EditEventBloc extends Bloc<EditEventEvent, EditEventState> {
  final AuthBloc authBloc;
  final DoEditEvent doEditEvent;

  EditEventBloc({required this.authBloc, required this.doEditEvent})
      : super(EditEventDefault()) {
    on<EditEventButtonPressed>(onEditEventButtonPressed);
  }

  onEditEventButtonPressed(EditEventButtonPressed event, emit) async {
    late Session session;
    if (authBloc.state is AuthorizedAdmin) {
      session = (authBloc.state as AuthorizedAdmin).session;
    } else {
      session = (authBloc.state as AuthorizedEmployee).session;
    }
    emit(EditEventLoading());
    try {
      await doEditEvent(session.jwtToken, event.params);
      emit(EditEventDefault());
    } catch (e) {
      emit(EditEventError(msg: mapErrorToMsg(e)));
    }
  }
}
