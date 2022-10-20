import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_read_contact_list.dart';

class ContactEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ImportContactsButtonPressed extends ContactEvent {
  final ReadContactListParams params;

  ImportContactsButtonPressed({required this.params});
}
