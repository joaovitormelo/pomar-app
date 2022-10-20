import 'package:equatable/equatable.dart';

class WhatsAppConnectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WhatsAppConnectionRefresh extends WhatsAppConnectionState {}

class WhatsAppConnectionHasQrCode extends WhatsAppConnectionState {
  final String qrCode;

  WhatsAppConnectionHasQrCode({required this.qrCode});
}

class WhatsAppConnectionConnected extends WhatsAppConnectionState {}

class WhatsAppConnectionError extends WhatsAppConnectionState {
  final String msg;

  WhatsAppConnectionError({required this.msg});
}
