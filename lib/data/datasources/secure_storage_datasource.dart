import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_home/core/errors/app_exception.dart';

class SecureStorageDatasource {
  SecureStorageDatasource({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (_) {
      throw const StorageException('Could not read secure settings.');
    }
  }

  Future<void> write(String key, String? value) async {
    try {
      if (value == null) {
        await _storage.delete(key: key);
      } else {
        await _storage.write(key: key, value: value);
      }
    } catch (_) {
      throw const StorageException('Could not save secure settings.');
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (_) {
      throw const StorageException('Could not update secure settings.');
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (_) {
      throw const StorageException('Could not reset the application.');
    }
  }
}
