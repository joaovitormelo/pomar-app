import 'package:equatable/equatable.dart';

class SwitchCompleteEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SwitchComplete extends SwitchCompleteEvent {
  final int idAssignment;
  final bool isCompleted;

  SwitchComplete({required this.idAssignment, required this.isCompleted});
}
