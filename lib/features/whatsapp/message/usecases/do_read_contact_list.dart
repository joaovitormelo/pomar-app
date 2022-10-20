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

abstract class ExcelReaderContract {
  Future<List<ContactModel>> readContactList(ReadContactListParams params);
}

class DoReadContactList {
  final ExcelReaderContract excelReader;

  DoReadContactList({required this.excelReader});

  call(ReadContactListParams params) async {
    return await excelReader.readContactList(params);
  }
}
