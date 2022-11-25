import 'package:pomar_app/features/schedule/data/datasources/schedule_server_source.dart';

class DoReadEventsByEmployee {
  final ScheduleServerSource scheduleServerSource;

  DoReadEventsByEmployee({required this.scheduleServerSource});

  call(String token, int idPerson) async {
    return await scheduleServerSource.readEventsByEmployee(token, idPerson);
  }
}
