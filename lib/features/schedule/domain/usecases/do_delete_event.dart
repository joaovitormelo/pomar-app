import 'package:pomar_app/features/schedule/data/datasources/schedule_server_source.dart';

class DeleteEventParams {
  final int idEvent;
  final List<String> excludeDates;

  DeleteEventParams({required this.idEvent, required this.excludeDates});
}

class DoDeleteEvent {
  final ScheduleServerSource scheduleServerSource;

  DoDeleteEvent({required this.scheduleServerSource});

  call(String token, DeleteEventParams params) async {
    await scheduleServerSource.deleteEvent(token, params);
  }
}
