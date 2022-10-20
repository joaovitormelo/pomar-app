import 'package:pomar_app/features/whatsapp/message/data/models/contact_model.dart';
import 'dart:io';

import 'package:pomar_app/features/whatsapp/message/usecases/do_read_contact_list.dart';

class ExcelReader implements ExcelReaderContract {
  @override
  Future<List<ContactModel>> readContactList(
      ReadContactListParams params) async {
    return [
      ContactModel(name: "João Vitor", number: "988338976"),
      ContactModel(name: "Fernanda", number: "988338976"),
      ContactModel(name: "Júlia", number: "988338976"),
      ContactModel(name: "João Vitor", number: "988338976"),
      ContactModel(name: "Fernanda", number: "988338976"),
      ContactModel(name: "Júlia", number: "988338976"),
      ContactModel(name: "João Vitor", number: "988338976"),
      ContactModel(name: "Fernanda", number: "988338976"),
      ContactModel(name: "Júlia", number: "988338976"),
    ];
  }
}
