import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/core/services/alarm_command_service.dart';
import 'package:secure_home/core/services/authentication_service.dart';
import 'package:secure_home/core/services/history_service.dart';
import 'package:secure_home/core/services/permission_service.dart';
import 'package:secure_home/core/services/secure_storage_service.dart';
import 'package:secure_home/core/services/settings_service.dart';
import 'package:secure_home/core/services/sim_card_service.dart';
import 'package:secure_home/core/services/sms_service.dart';
import 'package:secure_home/data/datasources/history_local_datasource.dart';
import 'package:secure_home/data/datasources/secure_storage_datasource.dart';
import 'package:secure_home/data/repositories/alarm_repository_impl.dart';
import 'package:secure_home/data/repositories/auth_repository_impl.dart';
import 'package:secure_home/data/repositories/history_repository_impl.dart';
import 'package:secure_home/data/repositories/settings_repository_impl.dart';
import 'package:secure_home/domain/repositories/alarm_repository.dart';
import 'package:secure_home/domain/repositories/auth_repository.dart';
import 'package:secure_home/domain/repositories/history_repository.dart';
import 'package:secure_home/domain/repositories/settings_repository.dart';

final secureStorageDatasourceProvider = Provider<SecureStorageDatasource>((ref) {
  return SecureStorageDatasource();
});

final historyLocalDatasourceProvider = Provider<HistoryLocalDatasource>((ref) {
  return HistoryLocalDatasource();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(secureStorageDatasourceProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(secureStorageDatasourceProvider));
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl(ref.watch(historyLocalDatasourceProvider));
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(ref.watch(secureStorageDatasourceProvider));
});

final smsServiceProvider = Provider<SmsService>((ref) => SmsService());

final simCardServiceProvider = Provider<SimCardService>((ref) {
  return SimCardService(ref.watch(smsServiceProvider));
});

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});

final historyServiceProvider = Provider<HistoryService>((ref) {
  return HistoryService(ref.watch(historyRepositoryProvider));
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(ref.watch(settingsRepositoryProvider));
});

final authenticationServiceProvider = Provider<AuthenticationService>((ref) {
  return AuthenticationService(ref.watch(authRepositoryProvider));
});

final alarmCommandServiceProvider = Provider<AlarmCommandService>((ref) {
  return AlarmCommandService(
    smsService: ref.watch(smsServiceProvider),
    historyService: ref.watch(historyServiceProvider),
    permissionService: ref.watch(permissionServiceProvider),
  );
});

final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return AlarmRepositoryImpl(
    commands: ref.watch(alarmCommandServiceProvider),
    settings: ref.watch(settingsServiceProvider),
  );
});
