import 'package:dio/dio.dart';
import 'package:pomar_app/core/config/server_routes.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';

class ScheduleServerSource {
  final Dio dio;

  ScheduleServerSource({required this.dio});

  readEvents(String token) async {
    Options options = Options(
      method: ServerRoutes.readEvents.method,
      headers: {
        "Authorization": token,
      },
    );
    Response response;
    try {
      response = await dio.request(
        ServerRoutes.readEvents.path,
        options: options,
      );
    } catch (e) {
      throw ConnectionError();
    }
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((event) => EventModel.fromJSON(event))
          .toList();
    } else {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }
}
