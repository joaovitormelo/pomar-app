import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/whatsapp/message/data/models/contact_model.dart';

class ContactState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactNoData extends ContactState {}

class ContactHasData extends ContactState {
  final List<ContactModel> contactList;

  ContactHasData({required this.contactList});
}

class ContactError extends ContactState {
  final String msg;

  ContactError({required this.msg});
}
