import 'package:pomar_app/core/errors/errors.dart';

const msgUserNotFoundError = "Usuário não encontrado!";
const msgUnauthorizedError = "Senha incorreta!";
const msgConnectionError = "Servidor indisponível no momento!";
const msgValidationError = "Email/senha inválidos!";
const msgServerError = "Algo deu errado! (erro: Server)";
const msgNetworkError = "Sem conexão com a internet!";
const msgStorageError = "Algo deu errado (erro: Storage)!";
const msgSessionError = "Sessão inválida ou expirada!";
const msgUnknownError = "Algo deu errado!";

String mapErrorToMsg(e) {
  print(e);
  if (e is UserNotFoundError) {
    return msgUserNotFoundError;
  } else if (e is UnauthorizedError) {
    return msgUnauthorizedError;
  } else if (e is ValidationError) {
    return msgValidationError;
  } else if (e is ConnectionError) {
    return msgConnectionError;
  } else if (e is ServerError) {
    return msgServerError;
  } else if (e is NetworkError) {
    return msgNetworkError;
  } else if (e is StorageError) {
    return msgStorageError;
  } else if (e is SessionError) {
    return msgSessionError;
  }
  return msgUnknownError;
}
