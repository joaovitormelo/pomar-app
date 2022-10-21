import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_states.dart';
import 'package:pomar_app/features/whatsapp/message/data/models/contact_model.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/send_messages_bloc/send_messages_event.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/send_messages_bloc/send_messages_state.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_send_messages.dart';

class SendMessagesBloc extends Bloc<SendMessagesEvent, SendMessagesState> {
  final AuthBloc authBloc;
  final DoSendMessages doSendMessages;

  SendMessagesBloc({required this.authBloc, required this.doSendMessages})
      : super(SendMessagesNoData()) {
    on<SendMessagesButtonPressed>(onSendMessagesButtonPressed);
  }

  onSendMessagesButtonPressed(SendMessagesButtonPressed event, emit) async {
    Session session = (authBloc.state as AuthorizedAdmin).session;
    emit(SendMessagesLoading());
    try {
      List<ContactModel> contactList =
          await doSendMessages(session.jwtToken, event.params);
      if (contactList.isEmpty) {
        emit(SendMessagesNoData());
      } else {
        emit(SendMessagesHasData(contactList: contactList));
      }
    } catch (e) {
      emit(SendMessagesError(msg: mapErrorToMsg(e)));
    }
  }
}
