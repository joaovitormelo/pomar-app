import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:pomar_app/features/whatsapp/message/data/models/contact_model.dart';
import 'package:excel/excel.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_read_contact_list.dart';

class ExcelManager implements ExcelManagerContract {
  @override
  Future<List<ContactModel>> readContactList(
      ReadContactListParams params) async {
    Uint8List bytes = await params.file.readAsBytes();
    Excel excel = Excel.decodeBytes(bytes);
    Sheet sheet = excel.tables[excel.tables.keys.first]!;

    List<ContactModel> contactList = [];

    for (var i = 0; i < sheet.rows.length; i++) {
      var row = sheet.rows[i];
      var nameColumn = row[params.nameColumn - 1];
      var phoneColumn = row[params.phoneColumn - 1];
      String name = nameColumn == null ? '' : nameColumn.value;
      String phone = phoneColumn == null ? '' : phoneColumn.value.toString();
      contactList.add(
        ContactModel(
          idContact: i,
          name: name,
          phone: phone,
          status: SentStatus.unsent,
        ),
      );
    }

    return contactList;
  }

  /*@override
  writeContactList(List<ContactModel> contactList) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['erros'];
    for (var i = 0; i < contactList.length; i++) {
      Data nameCell = sheetObject
          .cell(CellIndex.indexByColumnRow(rowIndex: i, columnIndex: 0));
      nameCell.value = contactList[i].name;
      Data phoneCell = sheetObject
          .cell(CellIndex.indexByColumnRow(rowIndex: i, columnIndex: 0));
      phoneCell.value = contactList[i].phone;
    }
    var result = excel.encode();
    File()
    print("Write contact list");
    inspect(result);
  }*/
}
