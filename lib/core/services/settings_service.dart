import 'package:secure_home/domain/entities/app_settings.dart';
import 'package:secure_home/domain/repositories/settings_repository.dart';

class SettingsService {
  SettingsService(this._repository);

  final SettingsRepository _repository;

  Future<AppSettings> load() => _repository.load();

  Future<void> save(AppSettings settings) => _repository.save(settings);

  Future<void> reset() => _repository.clearAll();
}
