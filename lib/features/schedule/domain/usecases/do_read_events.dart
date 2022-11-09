import 'package:pomar_app/features/schedule/data/datasources/schedule_server_source.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/data/models/routine_exclusion.dart';

class EventData {
  final EventModel event;
  final List<AssignmentModel> assignments;
  final List<RoutineExclusionModel> exclusions;

  EventData(
      {required this.event,
      required this.assignments,
      required this.exclusions});
}

class DoReadEvents {
  final ScheduleServerSource scheduleServerSource;

  DoReadEvents({required this.scheduleServerSource});

  call(String token) async {
    return await scheduleServerSource.readEvents(token);
  }
}
