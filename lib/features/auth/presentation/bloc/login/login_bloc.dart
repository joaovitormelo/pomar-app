import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/domain/usecases/do_login.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';

const msgUserNotFoundError = "Usuário não encontrado!";
const msgUnauthorizedError = "Senha incorreta!";
const msgConnectionError = "Servidor indisponível no momento!";
const msgValidationError = "Email/senha inválidos!";
const msgServerError = "Algo deu errado!";
const msgNetworkError = "Sem conexão com a internet!";
const msgUnknownError = "Algo deu errado!";

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final DoLogin doLoginUseCase;
  final AuthBloc authBloc;

  LoginBloc({required this.doLoginUseCase, required this.authBloc})
      : super(Default()) {
    on<DoLoginEvent>(onDoLoginEvent);
  }

  void onDoLoginEvent(DoLoginEvent event, emit) async {
    emit(Logging());
    try {
      Session? session = await doLoginUseCase(
          LoginParams(email: event.email, password: event.password));
      authBloc.add(DidLogin(session: session as Session));
      emit(Default());
    } catch (e) {
      if (e is UserNotFoundError) {
        emit(Error(message: msgUserNotFoundError));
      } else if (e is UnauthorizedError) {
        emit(Error(message: msgUnauthorizedError));
      } else if (e is ConnectionError) {
        emit(Error(message: msgConnectionError));
      } else if (e is ValidationError) {
        emit(Error(message: msgValidationError));
      } else if (e is ServerError) {
        emit(Error(message: msgServerError));
      } else if (e is NetworkError) {
        emit(Error(message: msgNetworkError));
      } else {
        print(e);
        emit(Error(message: msgUnknownError));
      }
    }
  }
}
