import 'package:pomar_app/features/schedule/data/datasources/schedule_server_source.dart';

class DoReadTasksByEmployee {
  final ScheduleServerSource scheduleServerSource;

  DoReadTasksByEmployee({required this.scheduleServerSource});

  call(String token, int idPerson) async {
    return await scheduleServerSource.readTasksByEmployee(token, idPerson);
  }
}
