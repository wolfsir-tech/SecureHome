class AppConstants {
  static const String appName = 'SecureHome';
  static const String version = '1.0.0';
  static const String androidChannel = 'com.securehome.app/device';

  static const int pinMinLength = 4;
  static const int pinMaxLength = 6;
  static const int patternMinLength = 4;
  static const int maxAuthAttempts = 5;
  static const Duration lockoutDuration = Duration(seconds: 30);
  static const Duration smsTimeout = Duration(seconds: 30);

  static const List<Duration> autoLockOptions = [
    Duration.zero,
    Duration(seconds: 30),
    Duration(minutes: 1),
    Duration(minutes: 5),
  ];
}
