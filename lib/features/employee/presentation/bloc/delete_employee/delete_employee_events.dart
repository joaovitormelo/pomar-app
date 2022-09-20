class DeleteEmployeeEvent {}

class DeleteEmployeeButtonPressed extends DeleteEmployeeEvent {
  final int idEmployee;

  DeleteEmployeeButtonPressed({required this.idEmployee});
}
