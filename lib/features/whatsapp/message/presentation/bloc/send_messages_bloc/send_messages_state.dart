import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/whatsapp/message/data/models/contact_model.dart';

class SendMessagesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMessagesNoData extends SendMessagesState {}

class SendMessagesLoading extends SendMessagesState {}

class SendMessagesHasData extends SendMessagesState {
  final List<ContactModel> contactList;

  SendMessagesHasData({required this.contactList});
}

class SendMessagesError extends SendMessagesState {
  final String msg;

  SendMessagesError({required this.msg});
}
