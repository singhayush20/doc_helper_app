abstract class ILocalStorageFacade {
  Future<void> saveUserEmail({required String emailAddress});
  Future<void> saveUid({required String uid});
  Future<void> saveLoggedIn({required bool isLoggedIn});

  Future<String?> getUserEmail();
  Future<String?> getUid();
  Future<bool?> getLoggedIn();

  Future<void> clear();
}
