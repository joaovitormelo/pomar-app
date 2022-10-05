import 'package:pomar_app/features/schedule/data/datasources/schedule_server_source.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';

class AddEventParams {
  final EventModel event;
  final List<AssignmentModel> assignmentList;

  AddEventParams({required this.event, required this.assignmentList});
}

class DoAddEvent {
  final ScheduleServerSource scheduleServerSource;

  DoAddEvent({required this.scheduleServerSource});

  call(String token, AddEventParams params) async {
    await scheduleServerSource.addEvent(token, params);
  }
}
