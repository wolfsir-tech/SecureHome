import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/domain/entities/alarm_state.dart';
import 'package:secure_home/domain/entities/app_settings.dart';
import 'package:secure_home/presentation/providers/providers.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  Future<void> hydrate() async {
    state = await ref.read(settingsServiceProvider).load();
  }

  Future<void> _persist(AppSettings next) async {
    state = next;
    await ref.read(settingsServiceProvider).save(next);
  }

  Future<void> completeOnboarding({
    required String phone,
    required bool pinEnabled,
    required bool patternEnabled,
    required bool biometricEnabled,
  }) async {
    await _persist(
      state.copyWith(
        onboardingComplete: true,
        alarmPhoneE164: phone,
        pinEnabled: pinEnabled,
        patternEnabled: patternEnabled,
        biometricEnabled: biometricEnabled,
        lastAlarmStatus: AlarmStatus.unknown,
      ),
    );
  }

  Future<void> setPhone(String phone) async {
    await _persist(state.copyWith(alarmPhoneE164: phone));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _persist(state.copyWith(themeMode: mode));
  }

  Future<void> setAutoLock(Duration duration) async {
    await _persist(state.copyWith(autoLockTimeout: duration));
  }

  Future<void> setSmsSubscription(int? id) async {
    await _persist(
      state.copyWith(
        smsSubscriptionId: id,
        clearSubscription: id == null,
      ),
    );
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _persist(state.copyWith(biometricEnabled: enabled));
  }

  Future<void> setPinEnabled(bool enabled) async {
    await _persist(state.copyWith(pinEnabled: enabled));
  }

  Future<void> setPatternEnabled(bool enabled) async {
    await _persist(state.copyWith(patternEnabled: enabled));
  }

  Future<void> setConfirmWithBiometrics(bool enabled) async {
    await _persist(state.copyWith(confirmWithBiometrics: enabled));
  }

  Future<void> setLastAlarm(AlarmStatus status) async {
    await _persist(
      state.copyWith(
        lastAlarmStatus: status,
        lastCommandAt: DateTime.now(),
      ),
    );
  }

  Future<void> resetApplication() async {
    await ref.read(settingsServiceProvider).reset();
    await ref.read(historyServiceProvider).clear();
    await ref.read(authenticationServiceProvider).clearCredentials();
    state = const AppSettings();
  }
}
