import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(Unitialized()) {
    on<AppInitialized>(onAppInitialized);
    on<DidLogin>(onDidLogin);
    on<LogoutEvent>(onLogoutEvent);
  }

  void onAppInitialized(AppInitialized event, emit) {
    emit(Unauthorized());
  }

  void onDidLogin(DidLogin event, emit) {
    inspect(event);
    if (event.session.user.typeUser == 0) {
      emit(AuthorizedAdmin(session: event.session));
    } else {
      emit(AuthorizedEmployee(session: event.session));
    }
  }

  void onLogoutEvent(LogoutEvent event, emit) {
    emit(Unauthorized());
  }
}
