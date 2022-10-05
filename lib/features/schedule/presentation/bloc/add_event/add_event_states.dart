import 'package:equatable/equatable.dart';

class AddEventStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddEventDefault extends AddEventStates {}

class AddEventLoading extends AddEventStates {}

class AddEventError extends AddEventStates {
  final String msg;

  AddEventError({required this.msg});
}
