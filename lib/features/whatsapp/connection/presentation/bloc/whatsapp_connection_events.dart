import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/whatsapp/connection/websockets/web_socket_client.dart';

class WhatsAppConnectionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class WhatsAppConnectionCheck extends WhatsAppConnectionEvent {}

class WhatsAppConnectionSet extends WhatsAppConnectionEvent {
  final WhatsAppWebSocketInfo info;

  WhatsAppConnectionSet({required this.info});
}

class WhatsAppConnectionDisconnectButtonPressed
    extends WhatsAppConnectionEvent {}
