import 'package:pomar_app/features/schedule/data/datasources/schedule_server_source.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';

class EditEventParams {
  final EventModel event;
  final List<AssignmentModel> assignmentList;

  EditEventParams({required this.event, required this.assignmentList});
}

class DoEditEvent {
  final ScheduleServerSource scheduleServerSource;

  DoEditEvent({required this.scheduleServerSource});

  call(String token, EditEventParams params) async {
    await scheduleServerSource.editEvent(token, params);
  }
}
