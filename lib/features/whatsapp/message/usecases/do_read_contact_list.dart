import 'dart:io';
import 'package:pomar_app/features/whatsapp/message/data/models/contact_model.dart';

class ReadContactListParams {
  final File file;
  final int nameColumn;
  final int phoneColumn;

  ReadContactListParams({
    required this.file,
    required this.nameColumn,
    required this.phoneColumn,
  });
}

abstract class ExcelManagerContract {
  Future<List<ContactModel>> readContactList(ReadContactListParams params);
  //Future<void> writeContactList(List<ContactModel> contactList);
}

class DoReadContactList {
  final ExcelManagerContract ExcelManager;

  DoReadContactList({required this.ExcelManager});

  call(ReadContactListParams params) async {
    return await ExcelManager.readContactList(params);
  }
}
