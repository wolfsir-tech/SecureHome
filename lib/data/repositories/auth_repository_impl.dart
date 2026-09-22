import 'package:secure_home/core/constants/storage_keys.dart';
import 'package:secure_home/core/utils/hash_utils.dart';
import 'package:secure_home/data/datasources/secure_storage_datasource.dart';
import 'package:secure_home/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._storage);

  final SecureStorageDatasource _storage;

  @override
  Future<void> setPin(String pin) async {
    final salt = HashUtils.randomSalt();
    final hash = HashUtils.hashSecret(pin, salt);
    await _storage.write(StorageKeys.pinSalt, salt);
    await _storage.write(StorageKeys.pinHash, hash);
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final salt = await _storage.read(StorageKeys.pinSalt);
    final hash = await _storage.read(StorageKeys.pinHash);
    if (salt == null || hash == null) return false;
    return HashUtils.verify(pin, salt, hash);
  }

  @override
  Future<void> setPattern(List<int> pattern) async {
    final salt = HashUtils.randomSalt();
    final hash = HashUtils.hashSecret(pattern.join('-'), salt);
    await _storage.write(StorageKeys.patternSalt, salt);
    await _storage.write(StorageKeys.patternHash, hash);
  }

  @override
  Future<bool> verifyPattern(List<int> pattern) async {
    final salt = await _storage.read(StorageKeys.patternSalt);
    final hash = await _storage.read(StorageKeys.patternHash);
    if (salt == null || hash == null) return false;
    return HashUtils.verify(pattern.join('-'), salt, hash);
  }

  @override
  Future<void> clearCredentials() async {
    await _storage.delete(StorageKeys.pinHash);
    await _storage.delete(StorageKeys.pinSalt);
    await _storage.delete(StorageKeys.patternHash);
    await _storage.delete(StorageKeys.patternSalt);
  }

  @override
  Future<bool> hasPin() async => await _storage.read(StorageKeys.pinHash) != null;

  @override
  Future<bool> hasPattern() async => await _storage.read(StorageKeys.patternHash) != null;
}
