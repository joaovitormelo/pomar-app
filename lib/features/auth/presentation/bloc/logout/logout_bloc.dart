import 'package:bloc/bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/domain/usecases/logout.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final Logout logoutUsecase;
  final AuthBloc authBloc;

  LogoutBloc({required this.logoutUsecase, required this.authBloc})
      : super(LogoutDefault()) {
    on<LogoutButtonPressed>(onLogoutButtonPressed);
  }

  void onLogoutButtonPressed(LogoutButtonPressed event, emit) async {
    authBloc.add(StartedLoading());
    Session session;
    if (authBloc.state is AuthorizedAdmin) {
      session = (authBloc.state as AuthorizedAdmin).session;
    } else {
      session = (authBloc.state as AuthorizedEmployee).session;
    }
    try {
      await logoutUsecase(session.idSession);
      authBloc.add(DidLogout());
      emit(LogoutDefault());
    } catch (e) {
      print(e);
      if (e is ConnectionError) {
        emit(LogoutError(message: msgConnectionError));
      } else if (e is ServerError) {
        emit(LogoutError(message: msgServerError));
      } else if (e is NetworkError) {
        emit(LogoutError(message: msgNetworkError));
      } else if (e is StorageError) {
        emit(LogoutError(message: msgStorageError));
      } else {
        emit(LogoutError(message: msgUnknownError));
      }
      authBloc.add(DidLogin(session: session));
    }
  }
}
