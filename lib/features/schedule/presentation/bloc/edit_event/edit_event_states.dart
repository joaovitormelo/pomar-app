import 'package:equatable/equatable.dart';

class EditEventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditEventDefault extends EditEventState {}

class EditEventLoading extends EditEventState {}

class EditEventError extends EditEventState {
  final String msg;

  EditEventError({required this.msg});
}
