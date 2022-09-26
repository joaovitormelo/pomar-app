import 'package:equatable/equatable.dart';

class AssignmentStatusModel extends Equatable {
  final int idAssignmentStatus;
  final int idEvent;
  final int idEmployee;
  final bool isCompleted;

  AssignmentStatusModel({
    required this.idAssignmentStatus,
    required this.idEvent,
    required this.idEmployee,
    required this.isCompleted,
  });

  factory AssignmentStatusModel.fromJSON(
      Map<String, dynamic> assignmentStatus) {
    return AssignmentStatusModel(
      idAssignmentStatus: assignmentStatus['idAssignmentStatus'],
      idEvent: assignmentStatus['idEvent'],
      idEmployee: assignmentStatus['idEmployee'],
      isCompleted: assignmentStatus['isCompleted'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id_assignment_status": idAssignmentStatus,
      "id_event": idEvent,
      "id_employee": idEmployee,
      "is_completed": isCompleted
    };
  }

  @override
  List<Object?> get props => [];
}
