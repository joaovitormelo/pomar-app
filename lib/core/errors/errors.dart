class UserNotFoundError implements Exception {}

class UnauthorizedError implements Exception {}

class ValidationError implements Exception {}

class ServerError implements Exception {}

class ConnectionError implements Exception {}

class EmptyResponseError implements Exception {}

class NetworkError implements Exception {}

class StorageError implements Exception {}

class SessionError implements Exception {}

class NoDataError implements Exception {}

Exception mapServerResponseToError(statusCode, responseData) {
  if (statusCode == 400) {
    throw ValidationError();
  } else if (statusCode == 401 && responseData["code"] == "001") {
    throw UnauthorizedError();
  } else if (statusCode == 401 && responseData["code"] == "002") {
    throw SessionError();
  } else if (statusCode == 404 && responseData["code"] == "002") {
    throw UserNotFoundError();
  } else if (statusCode == 404 && responseData["code"] == "003") {
    throw NoDataError();
  } else if (statusCode == 503 && responseData["code"] == "001") {
    throw ConnectionError();
  } else {
    throw ServerError();
  }
}
