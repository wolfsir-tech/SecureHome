abstract class AuthRepository {
  Future<void> setPin(String pin);
  Future<bool> verifyPin(String pin);
  Future<void> setPattern(List<int> pattern);
  Future<bool> verifyPattern(List<int> pattern);
  Future<void> clearCredentials();
  Future<bool> hasPin();
  Future<bool> hasPattern();
}
