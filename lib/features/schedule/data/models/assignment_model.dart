import 'package:equatable/equatable.dart';

class AssignmentModel extends Equatable {
  final int idAssignment;
  final int idEvent;
  final int idEmployee;
  final bool isCompleted;

  AssignmentModel({
    required this.idAssignment,
    required this.idEvent,
    required this.idEmployee,
    required this.isCompleted,
  });

  factory AssignmentModel.fromJSON(Map<String, dynamic> assignment) {
    return AssignmentModel(
      idAssignment: assignment['id_assignment'],
      idEvent: assignment['id_event'],
      idEmployee: assignment['id_employee'],
      isCompleted: assignment['is_completed'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id_assignment": idAssignment,
      "id_event": idEvent,
      "id_employee": idEmployee,
      "is_completed": isCompleted,
    };
  }

  @override
  List<Object?> get props => [idAssignment];
}
