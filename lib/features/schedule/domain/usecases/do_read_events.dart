import 'package:pomar_app/features/schedule/data/datasources/schedule_server_source.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';

class EventData {
  final EventModel event;
  final List<AssignmentModel> assignments;

  EventData({required this.event, required this.assignments});
}

class DoReadEvents {
  final ScheduleServerSource scheduleServerSource;

  DoReadEvents({required this.scheduleServerSource});

  call(String token) async {
    return await scheduleServerSource.readEvents(token);
  }
}
