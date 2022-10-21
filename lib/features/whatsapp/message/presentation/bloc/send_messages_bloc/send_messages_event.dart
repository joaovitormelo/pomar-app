import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_send_messages.dart';

class SendMessagesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMessagesButtonPressed extends SendMessagesEvent {
  final SendMessagesParams params;

  SendMessagesButtonPressed({required this.params});
}
