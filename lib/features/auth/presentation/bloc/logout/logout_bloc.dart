import 'package:bloc/bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/domain/usecases/logout.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';

mixin AuthorizedBloc {
  Session getSession(authBloc) {
    Session session;
    if (authBloc.state is AuthorizedAdmin) {
      session = (authBloc.state as AuthorizedAdmin).session;
    } else {
      session = (authBloc.state as AuthorizedEmployee).session;
    }
    return session;
  }
}

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> with AuthorizedBloc {
  final Logout logoutUsecase;
  final AuthBloc authBloc;

  LogoutBloc({required this.logoutUsecase, required this.authBloc})
      : super(LogoutDefault()) {
    on<LogoutButtonPressed>(onLogoutButtonPressed);
  }

  void onLogoutButtonPressed(LogoutButtonPressed event, emit) async {
    Session session = getSession(authBloc);
    try {
      await logoutUsecase(session.idSession);
      authBloc.add(DidLogout());
      emit(LogoutDefault());
    } catch (e) {
      emit(LogoutError(message: mapErrorToMsg(e)));
      authBloc.add(DidLogin(session: session));
      emit(LogoutDefault());
    }
  }
}
