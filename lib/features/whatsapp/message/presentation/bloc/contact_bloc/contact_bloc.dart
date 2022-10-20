import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/features/whatsapp/message/data/models/contact_model.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/contact_bloc/contact_events.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/contact_bloc/contact_states.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_read_contact_list.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  DoReadContactList doReadContactList;
  ContactBloc({required this.doReadContactList}) : super(ContactNoData()) {
    on<ImportContactsButtonPressed>(onImportContactsButtonPressed);
  }

  onImportContactsButtonPressed(ImportContactsButtonPressed event, emit) async {
    try {
      List<ContactModel> contactList = await doReadContactList(event.params);
      if (contactList.isEmpty) {
        emit(ContactNoData());
      } else {
        emit(ContactHasData(contactList: contactList));
      }
    } catch (e) {
      emit(ContactError(msg: mapErrorToMsg(e)));
    }
  }
}
