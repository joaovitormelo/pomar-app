import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pomar_app/core/config/server_routes.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/data/models/routine_exclusion.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_add_event.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_edit_event.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_delete_event.dart';

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
        inspect(eventData);
        List<RoutineExclusionModel> routineExclusionList =
            eventData["routine_exclusion_list"]
                .map<RoutineExclusionModel>((routineExclusion) =>
                    RoutineExclusionModel.fromJSON(routineExclusion))
                .toList();
        return EventData(
          event: EventModel.fromJSON(eventData['event']),
          assignments: assignments,
          exclusions: routineExclusionList,
        );
      }).toList();
      return eventDataList;
    } else {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }

  readEventsByEmployee(String token, int idPerson) async {
    Options options = Options(
      method: ServerRoutes.readEventsByEmployee.method,
      headers: {
        "Authorization": token,
      },
    );
    Response response;
    try {
      response = await dio.request(
        ServerRoutes.readEventsByEmployee.path,
        options: options,
        data: {
          "id_person": idPerson,
        },
      );
    } catch (e) {
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
        inspect(eventData);
        List<RoutineExclusionModel> routineExclusionList =
            eventData["routine_exclusion_list"]
                .map<RoutineExclusionModel>((routineExclusion) =>
                    RoutineExclusionModel.fromJSON(routineExclusion))
                .toList();
        return EventData(
          event: EventModel.fromJSON(eventData['event']),
          assignments: assignments,
          exclusions: routineExclusionList,
        );
      }).toList();
      return eventDataList;
    } else {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }

  addEvent(String token, AddEventParams params) async {
    Options options = Options(
      method: ServerRoutes.addEvent.method,
      headers: {
        "Authorization": token,
      },
    );
    Response response;
    try {
      response = await dio
          .request(ServerRoutes.addEvent.path, options: options, data: {
        "event": params.event.toJSON(),
        "assignment_list": params.assignmentList
            .map((assignment) => assignment.toJSON())
            .toList(),
      });
    } catch (e) {
      print(e);
      throw ConnectionError();
    }
    if (response.statusCode != 200) {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }

  editEvent(String token, EditEventParams params) async {
    Options options = Options(
      method: ServerRoutes.editEvent.method,
      headers: {
        "Authorization": token,
      },
    );
    Response response;
    try {
      response = await dio
          .request(ServerRoutes.editEvent.path, options: options, data: {
        "event": params.event.toJSON(),
        "assignment_list": params.assignmentList
            .map((assignment) => assignment.toJSON())
            .toList(),
      });
    } catch (e) {
      print(e);
      throw ConnectionError();
    }
    if (response.statusCode != 200) {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }

  deleteEvent(String token, DeleteEventParams params) async {
    Options options = Options(
      method: ServerRoutes.deleteEvent.method,
      headers: {
        "Authorization": token,
      },
    );
    Response response;
    try {
      response = await dio
          .request(ServerRoutes.deleteEvent.path, options: options, data: {
        "id_event": params.idEvent,
        "exclude_dates": params.excludeDates,
      });
    } catch (e) {
      print(e);
      throw ConnectionError();
    }
    if (response.statusCode != 200) {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }

  switchComplete(String token, int idAssignment, bool isCompleted) async {}
}
