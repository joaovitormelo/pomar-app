import 'package:pomar_app/features/schedule/data/datasources/schedule_server_source.dart';

class DoReadEvents {
  final ScheduleServerSource scheduleServerSource;

  DoReadEvents({required this.scheduleServerSource});

  call(String token) async {
    return await scheduleServerSource.readEvents(token);
  }
}
