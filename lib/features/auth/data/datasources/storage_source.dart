import 'package:pomar_app/core/errors/errors.dart';
import 'dart:convert';
import 'package:pomar_app/features/auth/data/models/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_SESSION = 'CACHED_SESSION';

abstract class StorageSourceContract {
  Future<void>? saveSession(SessionModel session);
}

class StorageSource implements StorageSourceContract {
  @override
  Future<void>? saveSession(SessionModel session) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
      CACHED_SESSION,
      json.encode(session.toJSON()),
    );
  }
}
