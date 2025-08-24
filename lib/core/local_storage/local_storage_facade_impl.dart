import 'package:doc_helper_app/core/local_storage/hive/hive_data_storage_handler.dart';
import 'package:doc_helper_app/core/local_storage/i_local_storage_facade.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:injectable/injectable.dart';

@Singleton(env: injectionEnv, as: ILocalStorageFacade)
class LocalStorageFacade implements ILocalStorageFacade {
  LocalStorageFacade(this._hiveDataStorageHandler);

  final HiveDataStorageHandler _hiveDataStorageHandler;

  @override
  Future<void> saveAuthToken({required String token}) async =>
      await _hiveDataStorageHandler.saveToken(token);

  @override
  Future<void> saveLoggedIn({required bool isLoggedIn}) async {
    await _hiveDataStorageHandler.saveLoggedIn(true);
  }

  @override
  Future<void> saveUid({required String uid}) async {
    await _hiveDataStorageHandler.saveUid(uid);
  }

  @override
  Future<void> saveUserEmail({required String emailAddress}) async {
    await _hiveDataStorageHandler.saveEmail(emailAddress);
  }

  @override
  Future<String?> getUserEmail() async =>
      _hiveDataStorageHandler.getUserEmail();

  @override
  Future<String?> getUid() async => _hiveDataStorageHandler.getUid();

  @override
  Future<String?> getAuthToken() async =>
      _hiveDataStorageHandler.getAuthToken();

  @override
  Future<bool?> getLoggedIn() async => _hiveDataStorageHandler.getLoggedIn();

  @override
  Future<void> clear() async => _hiveDataStorageHandler.clear();
}
