import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/domain/usecases/logout.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  Logout logoutUsecase;
  AuthBloc({required this.logoutUsecase}) : super(Unitialized()) {
    on<AppInitialized>(onAppInitialized);
    on<DidLogin>(onDidLogin);
    on<DidLogout>(onDidLogout);
    on<StartedLoading>(onStartedLoading);
  }

  void onAppInitialized(AppInitialized event, emit) {
    emit(Unauthorized());
  }

  void onDidLogin(DidLogin event, emit) {
    if (event.session.user.typeUser == 0) {
      emit(AuthorizedAdmin(session: event.session));
    } else {
      emit(AuthorizedEmployee(session: event.session));
    }
  }

  void onDidLogout(DidLogout event, emit) async {
    emit(Unauthorized());
  }

  void onStartedLoading(StartedLoading event, emit) async {
    emit(Loading());
  }
}
