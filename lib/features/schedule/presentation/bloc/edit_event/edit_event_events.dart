import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_edit_event.dart';

class EditEventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditEventButtonPressed extends EditEventEvent {
  final EditEventParams params;

  EditEventButtonPressed({required this.params});
}
