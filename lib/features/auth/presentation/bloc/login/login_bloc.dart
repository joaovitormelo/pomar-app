import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final DoLogin doLoginUseCase;
  final AuthBloc authBloc;

  LoginBloc({required this.doLoginUseCase, required this.authBloc})
      : super(LoginDefault()) {
    on<LoginButtonPressed>(onLoginButtonPressed);
  }

  void onLoginButtonPressed(LoginButtonPressed event, emit) async {
    emit(Logging());
    try {
      Session? session = await doLoginUseCase(
          LoginParams(email: event.email, password: event.password));
      authBloc.add(DidLogin(session: session as Session));
      emit(LoginDefault());
    } catch (e) {
      emit(mapErrorToMsg(e));
    }
  }
}
