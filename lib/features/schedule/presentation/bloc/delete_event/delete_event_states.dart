import 'package:equatable/equatable.dart';

class DeleteEventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeleteEventDefault extends DeleteEventState {}

class DeleteEventLoading extends DeleteEventState {}

class DeleteEventSuccess extends DeleteEventState {}

class DeleteEventError extends DeleteEventState {
  final String msg;

  DeleteEventError({required this.msg});
}
