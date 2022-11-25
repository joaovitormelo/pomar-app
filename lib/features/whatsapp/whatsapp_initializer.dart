import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pomar_app/features/whatsapp/connection/presentation/bloc/whatsapp_connection_bloc.dart';
import 'package:pomar_app/features/whatsapp/connection/usecases/do_check_connection.dart';
import 'package:pomar_app/features/whatsapp/connection/usecases/do_disconnect.dart';
import 'package:pomar_app/features/whatsapp/connection/websockets/web_socket_client.dart';
import 'package:pomar_app/features/whatsapp/data/whatsapp_source.dart';
import 'package:pomar_app/features/whatsapp/message/data/readers/excel_manager.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/contact_bloc/contact_bloc.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/send_messages_bloc/send_messages_bloc.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_read_contact_list.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_send_messages.dart';

class WhatsAppInitializer {
  final GetIt sl;
  final Dio dio;

  WhatsAppInitializer({required this.sl, required this.dio});

  Future<void> init() async {
    sl.registerFactory(() => WebSocketClient(bloc: sl()));

    sl.registerLazySingleton(
      () => WhatsAppConnectionBloc(
        authBloc: sl(),
        doCheckConnection: sl(),
        doDisconnect: sl(),
      ),
    );
    sl.registerFactory(
      () => ContactBloc(
        doReadContactList: sl(),
      ),
    );
    sl.registerFactory(
      () => SendMessagesBloc(
        authBloc: sl(),
        doSendMessages: sl(),
      ),
    );

    sl.registerFactory(() => DoCheckConnection(serverSource: sl()));
    sl.registerFactory(() => DoDisconnect(serverSource: sl()));
    sl.registerFactory(() => DoReadContactList(ExcelManager: sl()));
    sl.registerFactory(() => DoSendMessages(serverSource: sl()));

    sl.registerFactory<WhatsAppServerSource>(
      () => WhatsAppServerSource(dio: sl()),
    );
    sl.registerFactory<ExcelManagerContract>(() => ExcelManager());
  }
}
