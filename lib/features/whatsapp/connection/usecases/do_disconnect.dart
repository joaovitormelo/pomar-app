import 'package:pomar_app/features/whatsapp/data/whatsapp_source.dart';

class DoDisconnect {
  final WhatsAppServerSource serverSource;

  DoDisconnect({required this.serverSource});

  call(String jwtToken) async {
    return await serverSource.disconnect(jwtToken);
  }
}
