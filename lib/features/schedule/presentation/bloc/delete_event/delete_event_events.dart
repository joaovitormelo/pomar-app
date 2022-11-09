import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_delete_event.dart';

class DeleteEventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeleteEventButtonPressed extends DeleteEventEvent {
  final DeleteEventParams params;

  DeleteEventButtonPressed({required this.params});
}
