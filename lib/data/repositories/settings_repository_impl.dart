import 'package:flutter/material.dart';
import 'package:secure_home/core/constants/storage_keys.dart';
import 'package:secure_home/data/datasources/secure_storage_datasource.dart';
import 'package:secure_home/domain/entities/alarm_state.dart';
import 'package:secure_home/domain/entities/app_settings.dart';
import 'package:secure_home/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._storage);

  final SecureStorageDatasource _storage;

  @override
  Future<AppSettings> load() async {
    final onboarding = await _storage.read(StorageKeys.onboardingComplete);
    final phone = await _storage.read(StorageKeys.alarmPhone);
    final theme = await _storage.read(StorageKeys.themeMode);
    final timeout = await _storage.read(StorageKeys.autoLockTimeoutMs);
    final sub = await _storage.read(StorageKeys.smsSubscriptionId);
    final biometric = await _storage.read(StorageKeys.biometricEnabled);
    final pin = await _storage.read(StorageKeys.pinEnabled);
    final pattern = await _storage.read(StorageKeys.patternEnabled);
    final confirm = await _storage.read(StorageKeys.confirmWithBiometrics);
    final status = await _storage.read(StorageKeys.lastAlarmStatus);
    final lastAt = await _storage.read(StorageKeys.lastCommandAt);

    return AppSettings(
      onboardingComplete: onboarding == 'true',
      alarmPhoneE164: phone,
      themeMode: _themeFrom(theme),
      autoLockTimeout: Duration(milliseconds: int.tryParse(timeout ?? '') ?? 0),
      smsSubscriptionId: int.tryParse(sub ?? ''),
      biometricEnabled: biometric == 'true',
      pinEnabled: pin == 'true',
      patternEnabled: pattern == 'true',
      confirmWithBiometrics: confirm == 'true',
      lastAlarmStatus: AlarmStatusX.fromStorage(status),
      lastCommandAt: lastAt == null ? null : DateTime.tryParse(lastAt),
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await _storage.write(
      StorageKeys.onboardingComplete,
      settings.onboardingComplete ? 'true' : 'false',
    );
    await _storage.write(StorageKeys.alarmPhone, settings.alarmPhoneE164);
    await _storage.write(StorageKeys.themeMode, settings.themeMode.name);
    await _storage.write(
      StorageKeys.autoLockTimeoutMs,
      settings.autoLockTimeout.inMilliseconds.toString(),
    );
    await _storage.write(
      StorageKeys.smsSubscriptionId,
      settings.smsSubscriptionId?.toString(),
    );
    await _storage.write(
      StorageKeys.biometricEnabled,
      settings.biometricEnabled ? 'true' : 'false',
    );
    await _storage.write(StorageKeys.pinEnabled, settings.pinEnabled ? 'true' : 'false');
    await _storage.write(
      StorageKeys.patternEnabled,
      settings.patternEnabled ? 'true' : 'false',
    );
    await _storage.write(
      StorageKeys.confirmWithBiometrics,
      settings.confirmWithBiometrics ? 'true' : 'false',
    );
    await _storage.write(StorageKeys.lastAlarmStatus, settings.lastAlarmStatus.storageValue);
    await _storage.write(
      StorageKeys.lastCommandAt,
      settings.lastCommandAt?.toIso8601String(),
    );
  }

  @override
  Future<void> clearAll() => _storage.deleteAll();

  ThemeMode _themeFrom(String? value) {
    return ThemeMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}
