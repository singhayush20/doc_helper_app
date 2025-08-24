abstract class ILocalStorageFacade {
  Future<void> saveUserEmail({required String emailAddress});
  Future<void> saveUid({required String uid});
  Future<void> saveAuthToken({required String token});
  Future<void> saveLoggedIn({required bool isLoggedIn});

  Future<String?> getUserEmail();
  Future<String?> getUid();
  Future<String?> getAuthToken();
  Future<bool?> getLoggedIn();

  Future<void> clear();
}
