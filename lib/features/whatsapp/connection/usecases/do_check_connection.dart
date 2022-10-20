import 'package:pomar_app/features/whatsapp/data/whatsapp_source.dart';

enum WhatsAppConnectionStatus {
  refreshing,
  hasQrCode,
  connected,
}

class WhatsAppConnectionInfo {
  WhatsAppConnectionStatus state;
  String qrCode;

  WhatsAppConnectionInfo({required this.state, required this.qrCode});
}

class DoCheckConnection {
  final WhatsAppServerSource serverSource;

  DoCheckConnection({required this.serverSource});

  call(String jwtToken) async {
    return await serverSource.checkConnection(jwtToken);
  }
}
