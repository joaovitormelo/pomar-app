import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/whatsapp/message/data/models/contact_model.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_read_contact_list.dart';

class ContactEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ImportContactsButtonPressed extends ContactEvent {
  final ReadContactListParams params;

  ImportContactsButtonPressed({required this.params});
}

class UpdateContactsAfterSent extends ContactEvent {
  final List<ContactModel> contactList;

  UpdateContactsAfterSent({required this.contactList});
}

class RemoveContact extends ContactEvent {
  final int idContact;

  RemoveContact({required this.idContact});
}
