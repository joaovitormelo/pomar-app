import 'dart:convert';

import 'package:pomar_app/core/config/constants.dart';
import 'package:pomar_app/features/whatsapp/connection/presentation/bloc/whatsapp_connection_bloc.dart';
import 'package:pomar_app/features/whatsapp/connection/presentation/bloc/whatsapp_connection_events.dart';
import 'package:pomar_app/features/whatsapp/connection/usecases/do_check_connection.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WhatsAppWebSocketInfo {
  final WhatsAppConnectionInfo info;
  final bool hasError;

  WhatsAppWebSocketInfo({required this.info, required this.hasError});
}

class WebSocketClient {
  late WebSocketChannel channel;
  final WhatsAppConnectionBloc bloc;

  WebSocketClient({required this.bloc});

  init() {
    channel = WebSocketChannel.connect(
      Uri.parse("ws://${Constants.server}"),
    );

    channel.stream.listen(
      (data) {
        var message = jsonDecode(data);
        if (message.containsKey("qr")) {
          bloc.add(
            WhatsAppConnectionSet(
              info: WhatsAppWebSocketInfo(
                info: WhatsAppConnectionInfo(
                  state: WhatsAppConnectionStatus.hasQrCode,
                  qrCode: message["qr"],
                ),
                hasError: false,
              ),
            ),
          );
        } else if (message.containsKey("ready")) {
          bloc.add(
            WhatsAppConnectionSet(
              info: WhatsAppWebSocketInfo(
                info: WhatsAppConnectionInfo(
                    state: WhatsAppConnectionStatus.connected, qrCode: ""),
                hasError: false,
              ),
            ),
          );
        } else {
          bloc.add(
            WhatsAppConnectionSet(
              info: WhatsAppWebSocketInfo(
                info: WhatsAppConnectionInfo(
                    state: WhatsAppConnectionStatus.refreshing, qrCode: ""),
                hasError: false,
              ),
            ),
          );
        }
      },
      onError: (error) {
        print(error);
        bloc.add(
          WhatsAppConnectionSet(
            info: WhatsAppWebSocketInfo(
              info: WhatsAppConnectionInfo(
                  state: WhatsAppConnectionStatus.refreshing, qrCode: ""),
              hasError: true,
            ),
          ),
        );
      },
    );
  }
}
