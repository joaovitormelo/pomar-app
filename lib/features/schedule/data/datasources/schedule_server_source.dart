import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pomar_app/core/config/server_routes.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_add_event.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';

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
      print("HERE");
      print(e);
      throw ConnectionError();
    }
    if (response.statusCode == 200) {
      List<EventData> eventDataList =
          (response.data as List).map<EventData>((eventData) {
        List<AssignmentModel> assignments = eventData['assignments']
            .map<AssignmentModel>(
                (assignment) => AssignmentModel.fromJSON(assignment))
            .toList();
        return EventData(
            event: EventModel.fromJSON(eventData['event']),
            assignments: assignments);
      }).toList();
      return eventDataList;
    } else {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }

  addEvent(String token, AddEventParams params) async {}
}
