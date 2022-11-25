import 'package:bloc/bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_states.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_switch_complete.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/switch_complete_bloc/switch_complete_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/switch_complete_bloc/switch_complete_states.dart';

class SwitchCompleteBloc
    extends Bloc<SwitchCompleteEvent, SwitchCompleteState> {
  final AuthBloc authBloc;
  final DoSwitchComplete doSwitchComplete;

  SwitchCompleteBloc({required this.authBloc, required this.doSwitchComplete})
      : super(SwitchCompleteDefault()) {
    on<SwitchComplete>(onSwitchComplete);
  }

  onSwitchComplete(SwitchComplete event, emit) async {
    late Session session;
    if (authBloc.state is AuthorizedAdmin) {
      session = (authBloc.state as AuthorizedAdmin).session;
    } else {
      session = (authBloc.state as AuthorizedEmployee).session;
    }
    try {
      await doSwitchComplete(
          session.jwtToken, event.idAssignment, event.isCompleted);
      emit(SwitchCompleteFinished());
    } catch (e) {
      emit(SwitchCompleteError(msg: mapErrorToMsg(e)));
    }
    emit(SwitchCompleteDefault());
  }
}
