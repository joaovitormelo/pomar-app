import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfoContract {
  Future<bool>? checkConnection();
}

class NetworkInfo implements NetworkInfoContract {
  @override
  Future<bool>? checkConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }
}
