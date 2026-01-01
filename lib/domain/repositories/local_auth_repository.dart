abstract class LocalAuthRepository {
  Future<bool> isAuthAvailable();
  Future<bool> authenticate();
}
