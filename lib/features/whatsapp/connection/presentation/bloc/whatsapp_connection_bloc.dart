import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/whatsapp/connection/presentation/bloc/whatsapp_connection_events.dart';
import 'package:pomar_app/features/whatsapp/connection/presentation/bloc/whatsapp_connection_states.dart';
import 'package:pomar_app/features/whatsapp/connection/usecases/do_check_connection.dart';
import 'package:pomar_app/features/whatsapp/connection/usecases/do_disconnect.dart';
import 'package:pomar_app/features/whatsapp/connection/websockets/web_socket_client.dart';

class WhatsAppConnectionBloc
    extends Bloc<WhatsAppConnectionEvent, WhatsAppConnectionState> {
  final AuthBloc authBloc;
  final DoCheckConnection doCheckConnection;
  final DoDisconnect doDisconnect;

  WhatsAppConnectionBloc(
      {required this.authBloc,
      required this.doCheckConnection,
      required this.doDisconnect})
      : super(WhatsAppConnectionRefresh()) {
    on<WhatsAppConnectionCheck>(onWhatsAppConnectionCheck);
    on<WhatsAppConnectionSet>(onWhatsAppConnectionSet);
    on<WhatsAppConnectionDisconnectButtonPressed>(
        onWhatsAppConnectionDisconnectButtonPressed);
  }

  onWhatsAppConnectionCheck(WhatsAppConnectionCheck event, emit) async {
    Session session = (authBloc.state as AuthorizedAdmin).session;
    try {
      WhatsAppConnectionInfo info = await doCheckConnection(session.jwtToken);
      if (info.state == WhatsAppConnectionStatus.refreshing) {
        emit(WhatsAppConnectionRefresh());
      } else if (info.state == WhatsAppConnectionStatus.hasQrCode) {
        emit(WhatsAppConnectionHasQrCode(qrCode: info.qrCode));
      } else {
        emit(WhatsAppConnectionConnected());
      }
    } catch (e) {
      emit(WhatsAppConnectionError(msg: mapErrorToMsg(e)));
    }
  }

  onWhatsAppConnectionSet(WhatsAppConnectionSet event, emit) async {
    WhatsAppWebSocketInfo info = event.info;
    if (info.hasError) {
      emit(WhatsAppConnectionError(msg: "Erro de conexão"));
    } else if (info.info.state == WhatsAppConnectionStatus.refreshing) {
      emit(WhatsAppConnectionRefresh());
    } else if (info.info.state == WhatsAppConnectionStatus.hasQrCode) {
      emit(WhatsAppConnectionHasQrCode(qrCode: info.info.qrCode));
    } else {
      emit(WhatsAppConnectionConnected());
    }
  }

  onWhatsAppConnectionDisconnectButtonPressed(
      WhatsAppConnectionDisconnectButtonPressed event, emit) async {
    Session session = (authBloc.state as AuthorizedAdmin).session;
    try {
      await doDisconnect(session.jwtToken);
      emit(WhatsAppConnectionRefresh());
    } catch (e) {
      emit(WhatsAppConnectionError(msg: mapErrorToMsg(e)));
    }
  }
}
