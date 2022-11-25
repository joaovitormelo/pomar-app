import 'package:pomar_app/features/schedule/data/datasources/schedule_server_source.dart';

class DoSwitchComplete {
  final ScheduleServerSource scheduleServerSource;

  DoSwitchComplete({required this.scheduleServerSource});

  call(String token, int idAssignment, bool isCompleted) async {
    return await scheduleServerSource.switchComplete(
      token,
      idAssignment,
      isCompleted,
    );
  }
}
