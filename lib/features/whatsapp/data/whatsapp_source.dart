import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pomar_app/core/config/server_routes.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/whatsapp/connection/usecases/do_check_connection.dart';

class WhatsAppServerSource {
  final Dio dio;

  WhatsAppServerSource({required this.dio});

  checkConnection(String jwtToken) async {
    Options options = Options(
      method: ServerRoutes.checkConnectionWhats.method,
      headers: {"Authorization": jwtToken},
    );
    Response response;
    try {
      response = await dio.request(
        ServerRoutes.checkConnectionWhats.path,
        options: options,
      );
    } catch (e) {
      print(e);
      throw ConnectionError();
    }
    print(response);
    if (response.statusCode == 200) {
      if (response.data["err"]) {
        return WhatsAppConnectionInfo(
          state: WhatsAppConnectionStatus.refreshing,
          qrCode: "",
        );
      } else if (response.data["qr"] == "") {
        return WhatsAppConnectionInfo(
          state: WhatsAppConnectionStatus.connected,
          qrCode: "",
        );
      } else {
        return WhatsAppConnectionInfo(
          state: WhatsAppConnectionStatus.hasQrCode,
          qrCode: response.data["qr"],
        );
      }
    } else {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }

  disconnect(String jwtToken) async {
    Options options = Options(
      method: ServerRoutes.disconnectWhats.method,
      headers: {"Authorization": jwtToken},
    );
    Response response;
    try {
      response = await dio.request(
        ServerRoutes.disconnectWhats.path,
        options: options,
      );
    } catch (e) {
      print(e);
      throw ConnectionError();
    }
    if (response.statusCode != 200) {
      throw mapServerResponseToError(response.statusCode, response.data);
    }
  }
}
