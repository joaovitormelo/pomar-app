import 'package:bloc/bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_validate_session.dart';
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

  Future<bool> validateSession(session, authBloc, doValidateSession, emit,
      defaultState, errorState) async {
    try {
      await doValidateSession(session);
      return true;
    } catch (e) {
      if (e is SessionError) {
        emit(errorState(message: msgSessionError));
        authBloc.add(DidLogout());
        emit(defaultState());
      } else {
        emit(errorState(message: mapErrorToMsg(e)));
        emit(defaultState());
      }
      return false;
    }
  }
}

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> with AuthorizedBloc {
  final DoValidateSession doValidateSession;
  final Logout logoutUsecase;
  final AuthBloc authBloc;

  LogoutBloc(
      {required this.doValidateSession,
      required this.logoutUsecase,
      required this.authBloc})
      : super(LogoutDefault()) {
    on<LogoutButtonPressed>(onLogoutButtonPressed);
  }

  void onLogoutButtonPressed(LogoutButtonPressed event, emit) async {
    Session session = getSession(authBloc);
    bool isValidSession = await validateSession(
      session,
      authBloc,
      doValidateSession,
      emit,
      LogoutDefault,
      LogoutError,
    );
    if (isValidSession) {
      authBloc.add(StartedLoading());
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
}
