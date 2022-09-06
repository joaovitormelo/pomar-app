import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/core/errors/errors.dart';
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
      print(e);
      if (e is UserNotFoundError) {
        emit(LoginError(message: msgUserNotFoundError));
      } else if (e is UnauthorizedError) {
        emit(LoginError(message: msgUnauthorizedError));
      } else if (e is ConnectionError) {
        emit(LoginError(message: msgConnectionError));
      } else if (e is ValidationError) {
        emit(LoginError(message: msgValidationError));
      } else if (e is ServerError) {
        emit(LoginError(message: msgServerError));
      } else if (e is NetworkError) {
        emit(LoginError(message: msgNetworkError));
      } else if (e is StorageError) {
        emit(LoginError(message: msgStorageError));
      } else {
        emit(LoginError(message: msgUnknownError));
      }
    }
  }
}
