import 'package:secure_home/data/datasources/secure_storage_datasource.dart';

class SecureStorageService {
  SecureStorageService(this._datasource);

  final SecureStorageDatasource _datasource;

  Future<String?> read(String key) => _datasource.read(key);

  Future<void> write(String key, String? value) => _datasource.write(key, value);

  Future<void> delete(String key) => _datasource.delete(key);

  Future<void> deleteAll() => _datasource.deleteAll();
}
