import 'package:get_it/get_it.dart';
import 'package:pomar_app/features/auth/login_initializer.dart';

class Initializer {
  Future<void> init() async {
    await LoginInitializer().init();
  }
}
