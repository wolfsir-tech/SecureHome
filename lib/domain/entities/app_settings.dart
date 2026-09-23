import 'package:flutter/material.dart';
import 'package:secure_home/domain/entities/alarm_state.dart';

enum AppLocale {
  system('system'),
  en('en'),
  fa('fa');

  const AppLocale(this.code);

  final String code;

  static AppLocale fromCode(String? code) {
    return AppLocale.values.firstWhere(
      (e) => e.code == code,
      orElse: () => AppLocale.system,
    );
  }
}

extension AppLocaleX on AppLocale {
  /// Resolves the app locale to a [Locale], or null to follow the platform.
  Locale? toLocale() {
    switch (this) {
      case AppLocale.system:
        return null;
      case AppLocale.en:
        return const Locale('en');
      case AppLocale.fa:
        return const Locale('fa');
    }
  }
}

class AppSettings {
  const AppSettings({
    this.onboardingComplete = false,
    this.alarmPhoneE164,
    this.themeMode = ThemeMode.system,
    this.locale = AppLocale.system,
    this.autoLockTimeout = Duration.zero,
    this.smsSubscriptionId,
    this.biometricEnabled = false,
    this.pinEnabled = false,
    this.patternEnabled = false,
    this.confirmWithBiometrics = false,
    this.lastAlarmStatus = AlarmStatus.unknown,
    this.lastCommandAt,
  });

  final bool onboardingComplete;
  final String? alarmPhoneE164;
  final ThemeMode themeMode;
  final AppLocale locale;
  final Duration autoLockTimeout;
  final int? smsSubscriptionId;
  final bool biometricEnabled;
  final bool pinEnabled;
  final bool patternEnabled;
  final bool confirmWithBiometrics;
  final AlarmStatus lastAlarmStatus;
  final DateTime? lastCommandAt;

  bool get hasFallbackLock => pinEnabled || patternEnabled;

  AppSettings copyWith({
    bool? onboardingComplete,
    String? alarmPhoneE164,
    bool clearPhone = false,
    ThemeMode? themeMode,
    AppLocale? locale,
    Duration? autoLockTimeout,
    int? smsSubscriptionId,
    bool clearSubscription = false,
    bool? biometricEnabled,
    bool? pinEnabled,
    bool? patternEnabled,
    bool? confirmWithBiometrics,
    AlarmStatus? lastAlarmStatus,
    DateTime? lastCommandAt,
    bool clearLastCommand = false,
  }) {
    return AppSettings(
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      alarmPhoneE164: clearPhone ? null : (alarmPhoneE164 ?? this.alarmPhoneE164),
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      smsSubscriptionId:
          clearSubscription ? null : (smsSubscriptionId ?? this.smsSubscriptionId),
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinEnabled: pinEnabled ?? this.pinEnabled,
      patternEnabled: patternEnabled ?? this.patternEnabled,
      confirmWithBiometrics: confirmWithBiometrics ?? this.confirmWithBiometrics,
      lastAlarmStatus: lastAlarmStatus ?? this.lastAlarmStatus,
      lastCommandAt: clearLastCommand ? null : (lastCommandAt ?? this.lastCommandAt),
    );
  }
}
