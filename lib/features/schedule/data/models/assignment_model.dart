import 'package:equatable/equatable.dart';

class AssignmentModel extends Equatable {
  final int idAssignment;
  final int idEventInfo;
  final int idEmployee;

  AssignmentModel(
      {required this.idAssignment,
      required this.idEventInfo,
      required this.idEmployee});

  factory AssignmentModel.fromJSON(Map<String, dynamic> assignment) {
    return AssignmentModel(
        idAssignment: assignment['id_assignment'],
        idEventInfo: assignment['id_event_info'],
        idEmployee: assignment['id_employee']);
  }

  Map<String, dynamic> toJSON() {
    return {
      "id_assignment": idAssignment,
      "id_event_info": idEventInfo,
      "id_employee": idEmployee,
    };
  }

  @override
  List<Object?> get props => [];
}
