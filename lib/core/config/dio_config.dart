import 'package:dio/dio.dart';
import 'package:pomar_app/core/config/constants.dart';

class DioConfig {
  static Dio getInstance() {
    BaseOptions options = BaseOptions(
      baseUrl: Constants.serverUrl,
      connectTimeout: 5000,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return Dio(options);
  }
}
