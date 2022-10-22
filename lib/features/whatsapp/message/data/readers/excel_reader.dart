import 'dart:developer';
import 'dart:typed_data';

import 'package:pomar_app/features/whatsapp/message/data/models/contact_model.dart';
import 'package:excel/excel.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_read_contact_list.dart';

class ExcelReader implements ExcelReaderContract {
  @override
  Future<List<ContactModel>> readContactList(
      ReadContactListParams params) async {
    Uint8List bytes = await params.file.readAsBytes();
    Excel excel = Excel.decodeBytes(bytes);
    Sheet sheet = excel.tables[excel.tables.keys.first]!;

    List<ContactModel> contactList = [];

    for (var i = 0; i < sheet.rows.length; i++) {
      var row = sheet.rows[i];
      contactList.add(
        ContactModel(
          idContact: i,
          name: row[params.nameColumn - 1]!.value,
          phone: row[params.phoneColumn - 1]!.value.toString(),
          status: SentStatus.unsent,
        ),
      );
    }

    return contactList;
  }
}
