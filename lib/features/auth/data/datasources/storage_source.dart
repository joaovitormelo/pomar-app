import 'dart:convert';
import 'dart:developer';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/data/models/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_SESSION = 'CACHED_SESSION';

abstract class StorageSourceContract {
  Future<void>? saveSession(SessionModel session);
  Future<void> removeSavedSession();
  Future<SessionModel> getSavedSession();
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

  @override
  Future<void> removeSavedSession() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(CACHED_SESSION);
  }

  @override
  Future<SessionModel> getSavedSession() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    try {
      SessionModel session = SessionModel.fromJSON(
          json.decode(sharedPreferences.getString(CACHED_SESSION) as String));
      inspect(session);
      return session;
    } catch (e) {
      throw StorageError();
    }
  }
}
