import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/features/whatsapp/connection/presentation/bloc/whatsapp_connection_bloc.dart';
import 'package:pomar_app/features/whatsapp/connection/presentation/bloc/whatsapp_connection_events.dart';
import 'package:pomar_app/features/whatsapp/connection/presentation/bloc/whatsapp_connection_states.dart';
import 'package:pomar_app/features/whatsapp/connection/websockets/web_socket_client.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:badges/badges.dart';

class WhatsAppConnectPage extends StatefulWidget {
  const WhatsAppConnectPage({Key? key}) : super(key: key);

  @override
  State<WhatsAppConnectPage> createState() => _WhatsAppConnectPageState();
}

class _WhatsAppConnectPageState extends State<WhatsAppConnectPage> {
  late WebSocketClient wsClient;

  @override
  void initState() {
    super.initState();
    wsClient = Globals.sl<WebSocketClient>();
    wsClient.init();
    Globals.sl<WhatsAppConnectionBloc>().add(WhatsAppConnectionCheck());
  }

  @override
  void dispose() {
    super.dispose();
    wsClient.channel.sink.close();
  }

  onDisconnectButtonPressed() {
    Globals.sl<WhatsAppConnectionBloc>()
        .add(WhatsAppConnectionDisconnectButtonPressed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conexão com WhatsApp"),
      ),
      body: Center(
        child: BlocBuilder<WhatsAppConnectionBloc, WhatsAppConnectionState>(
          builder: (context, state) {
            print(state);
            if (state is WhatsAppConnectionHasQrCode) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Escaneie o QR Code",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 30),
                  QrImage(
                    data: state.qrCode,
                    version: QrVersions.auto,
                    size: 200,
                  ),
                ],
              );
            } else if (state is WhatsAppConnectionConnected) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Badge(
                        badgeColor: Colors.green,
                      ),
                      const Text(
                        " Conectado",
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: onDisconnectButtonPressed,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    child: Text("Desconectar"),
                  )
                ],
              );
            } else if (state is WhatsAppConnectionError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Erro durante a conexão",
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 30),
                  Icon(
                    Icons.warning,
                    color: Color.fromARGB(255, 255, 6, 6),
                    size: 50,
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Atualizando a conexão",
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 30),
                  CircularProgressIndicator(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
