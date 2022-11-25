import 'package:pomar_app/features/whatsapp/data/whatsapp_source.dart';
import 'package:pomar_app/features/whatsapp/message/data/models/contact_model.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_read_contact_list.dart';

class SendMessagesParams {
  final List<ContactModel> contactList;
  final String msg;

  SendMessagesParams({required this.contactList, required this.msg});
}

class DoSendMessages {
  final WhatsAppServerSource serverSource;

  DoSendMessages({required this.serverSource});

  call(String token, SendMessagesParams params) async {
    return await serverSource.sendMessages(token, params);
  }
}
