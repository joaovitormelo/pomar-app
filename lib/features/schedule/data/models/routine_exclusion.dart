import 'package:equatable/equatable.dart';

class RoutineExclusionModel extends Equatable {
  final int idRoutineExclusion;
  final int idEvent;
  final String date;

  RoutineExclusionModel({
    required this.idRoutineExclusion,
    required this.idEvent,
    required this.date,
  });

  factory RoutineExclusionModel.fromJSON(
      Map<String, dynamic> routineExclusion) {
    return RoutineExclusionModel(
      idRoutineExclusion: routineExclusion['id_routine_exclusion'],
      idEvent: routineExclusion['id_event'],
      date: routineExclusion['date'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id_routine_exclusion": idRoutineExclusion,
      "id_event": idEvent,
      "date": date,
    };
  }

  @override
  List<Object?> get props => [idEvent, date];
}
