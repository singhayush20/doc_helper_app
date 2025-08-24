import 'package:doc_helper_app/core/local_storage/hive/hive_box_handler.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HiveDataStorageHandler {
  HiveDataStorageHandler(this._hiveBoxHandler);

  final HiveBoxHandler _hiveBoxHandler;

  static const String keyEmail = 'email';
  static const String keyToken = 'authToken';
  static const String uid = 'uid';
  static const String keyLoggedIn = 'isLoggedIn';

  Future<void> saveEmail(String email) async {
    await _hiveBoxHandler.appStorageBox.put(keyEmail, email);
  }

  Future<String?> getUserEmail() async =>
      _hiveBoxHandler.appStorageBox.get(keyEmail);

  Future<void> saveToken(String token) async {
    await _hiveBoxHandler.appStorageBox.put(keyToken, token);
  }

  Future<String?> getAuthToken() async =>
      _hiveBoxHandler.appStorageBox.get(keyToken);

  Future<void> saveLoggedIn(bool isLoggedIn) async {
    await _hiveBoxHandler.appStorageBox.put(keyLoggedIn, isLoggedIn);
  }

  Future<bool?> getLoggedIn() async =>
      _hiveBoxHandler.appStorageBox.get(keyLoggedIn);

  Future<void> saveUid(String uid) async {
    await _hiveBoxHandler.appStorageBox.put(uid, uid);
  }

  Future<String?> getUid() async => _hiveBoxHandler.appStorageBox.get(uid);

  Future<void> clear() async => _hiveBoxHandler.clear();
}
