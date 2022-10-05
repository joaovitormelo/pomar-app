import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_add_event.dart';

class AddEventEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddEventButtonPressed extends AddEventEvents {
  final AddEventParams addEventParams;

  AddEventButtonPressed({required this.addEventParams});
}
