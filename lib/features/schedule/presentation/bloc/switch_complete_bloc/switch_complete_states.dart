import 'package:equatable/equatable.dart';

class SwitchCompleteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SwitchCompleteDefault extends SwitchCompleteState {}

class SwitchCompleteFinished extends SwitchCompleteState {}

class SwitchCompleteError extends SwitchCompleteState {
  final String msg;

  SwitchCompleteError({required this.msg});
}
