// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SecureHome';

  @override
  String get tagline => 'Home security, simply.';

  @override
  String get welcomeHeadline => 'Protect your home. Simply.';

  @override
  String get welcomeBody =>
      'SecureHome sends SMS commands to your GSM alarm. No cloud. No account. Just this device and your alarm SIM.';

  @override
  String get getStarted => 'Get started';

  @override
  String get enterApp => 'Enter SecureHome';

  @override
  String get continueButton => 'Continue';

  @override
  String get notNow => 'Not now';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get reset => 'Reset';

  @override
  String get clear => 'Clear';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get alarmPhoneLabel => 'Alarm phone number';

  @override
  String get alarmPhoneHint =>
      'Enter the SIM card number inside your alarm system.';

  @override
  String get alarmPhoneExample => '+98 912 123 4567';

  @override
  String get notSet => 'Not set';

  @override
  String get invalidAlarmPhone => 'The alarm phone number is invalid.';

  @override
  String get armAlarm => 'ARM ALARM';

  @override
  String get disarmAlarm => 'DISARM';

  @override
  String get activate => 'Activate';

  @override
  String get disableAlarm => 'Disable Alarm';

  @override
  String get armConfirmTitle => 'Activate home alarm?';

  @override
  String get armConfirmMessage =>
      'An SMS command will be sent to the alarm system.';

  @override
  String get disarmConfirmTitle => 'Disable home alarm?';

  @override
  String get disarmConfirmMessage =>
      'Are you sure you want to send the deactivation command?';

  @override
  String get biometricReasonArm => 'Confirm this alarm command';

  @override
  String get commandCancelled => 'Command cancelled.';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get noCommandsYet => 'No commands yet.';

  @override
  String lastCommandAt(String time) {
    return 'Last command $time';
  }

  @override
  String get alarmArmed => 'Alarm armed';

  @override
  String get alarmDisarmed => 'Alarm disarmed';

  @override
  String get statusSecuredTitle => 'HOME SECURED';

  @override
  String get statusSecuredSubtitle => 'Home is secured';

  @override
  String get statusDisarmedTitle => 'ALARM DISARMED';

  @override
  String get statusDisarmedSubtitle => 'Alarm is disarmed';

  @override
  String get statusActivatingTitle => 'ACTIVATING';

  @override
  String get statusDeactivatingTitle => 'DEACTIVATING';

  @override
  String get statusSendingTitle => 'SENDING SMS';

  @override
  String get statusSendingSubtitle => 'Sending command...';

  @override
  String get statusErrorTitle => 'ERROR';

  @override
  String get statusErrorSubtitle => 'Unable to send command';

  @override
  String get statusUnknownTitle => 'STATUS UNKNOWN';

  @override
  String get statusUnknownSubtitle => 'Send a command to update status';

  @override
  String get statusSendingSemantic => 'Sending command';

  @override
  String get statusUnknownSemantic => 'Alarm status unknown';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get securitySection => 'Security';

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get alarmSection => 'Alarm';

  @override
  String get applicationSection => 'Application';

  @override
  String get changePin => 'Change PIN';

  @override
  String get changePattern => 'Change pattern';

  @override
  String get fingerprint => 'Fingerprint';

  @override
  String get unlockBiometricFirst => 'Unlock with biometrics first';

  @override
  String get biometricReasonEnable => 'Enable fingerprint unlock';

  @override
  String get confirmActionsBiometric => 'Confirm actions with fingerprint';

  @override
  String get autoLock => 'Auto-lock';

  @override
  String get testSms => 'Test SMS';

  @override
  String get checking => 'Checking...';

  @override
  String get smsSim => 'SMS SIM';

  @override
  String get theme => 'Theme';

  @override
  String get about => 'About';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get resetApplication => 'Reset application';

  @override
  String get lightMode => 'Light mode';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get systemDefault => 'System default';

  @override
  String get defaultSim => 'Default SIM';

  @override
  String get askSystemDefault => 'Ask system default';

  @override
  String simCard(int id) {
    return 'SIM $id';
  }

  @override
  String get insertSim => 'Please insert a SIM card.';

  @override
  String get checkSimCard => 'Check your SIM card';

  @override
  String get readyToSend => 'Ready to send commands.';

  @override
  String get resetConfirmTitle => 'Reset application?';

  @override
  String get resetConfirmMessage =>
      'This erases the alarm number, lock, and history on this device.';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePersian => 'فارسی';

  @override
  String get themeAndLanguage => 'Theme & language';

  @override
  String get confirmIdentity => 'Confirm it is you';

  @override
  String get chooseNewPin => 'Choose a new PIN';

  @override
  String get drawNewPattern => 'Draw a new pattern';

  @override
  String get confirmNewPin => 'Confirm your new PIN';

  @override
  String get confirmNewPattern => 'Confirm your new pattern';

  @override
  String get savePin => 'Save PIN';

  @override
  String get noMatch => 'That did not match. Try again.';

  @override
  String get pinsNoMatch => 'Those PINs did not match.';

  @override
  String get patternsNoMatch => 'Those patterns did not match.';

  @override
  String get patternTooShort => 'Connect at least 4 dots.';

  @override
  String get changePhoneAuthReason => 'Confirm to change the alarm number';

  @override
  String get changePhoneGateMessage =>
      'Changing the alarm number requires authentication.';

  @override
  String get useFingerprint => 'Use fingerprint';

  @override
  String get changeAlarmPhone => 'Change alarm phone number';

  @override
  String get useSimCardNumber => 'Use the SIM card number inside the alarm.';

  @override
  String get saveNumber => 'Save number';

  @override
  String get aboutTitle => 'About';

  @override
  String get privacyTitle => 'Privacy information';

  @override
  String get privacyBody =>
      'SecureHome works entirely on this device. It does not create an account and does not talk to a server. Alarm commands are sent as SMS to the number you save. Your PIN and pattern are stored only as one-way hashes in secure storage.';

  @override
  String get historyTitle => 'History';

  @override
  String get clearHistoryTitle => 'Clear history?';

  @override
  String get clearHistoryMessage => 'This only removes local command records.';

  @override
  String get lockTitle => 'Unlock SecureHome';

  @override
  String get lockBiometricHint => 'Use your fingerprint';

  @override
  String get lockPinHint => 'Enter your PIN';

  @override
  String get lockPatternHint => 'Draw your pattern';

  @override
  String get usePin => 'Use PIN';

  @override
  String get usePattern => 'Use pattern';

  @override
  String tooManyAttempts(int seconds) {
    return 'Too many attempts. Try again in ${seconds}s.';
  }

  @override
  String get createPinTitle => 'Create a PIN';

  @override
  String get confirmPinTitle => 'Confirm your PIN';

  @override
  String get pinSubtitle => '4 to 6 digits. This keeps SecureHome locked.';

  @override
  String get drawPatternTitle => 'Draw a pattern';

  @override
  String get confirmPatternTitle => 'Confirm your pattern';

  @override
  String get numericPin => 'Numeric PIN';

  @override
  String get numericPinDesc => 'A 4 to 6 digit code';

  @override
  String get patternLock => 'Pattern lock';

  @override
  String get connectFourDots => 'Connect at least 4 dots';

  @override
  String get biometricNotAvailable => 'Not available on this device';

  @override
  String get lockMethodsTitle => 'Lock SecureHome';

  @override
  String get lockMethodsBody =>
      'Choose how you unlock the app. A PIN or pattern is required.';

  @override
  String get biometricStepTitle => 'Use fingerprint';

  @override
  String get biometricStepBody =>
      'Unlock SecureHome faster with the fingerprint already on this device.';

  @override
  String get biometricStepBodyUnavailable =>
      'Fingerprint is not available on this device.';

  @override
  String get enableFingerprint => 'Enable fingerprint';

  @override
  String get biometricNotVerified => 'Fingerprint was not verified.';

  @override
  String get allowSmsTitle => 'Allow SMS';

  @override
  String get allowSmsBody =>
      'SecureHome needs SMS permission to send commands to your alarm.';

  @override
  String get allowSmsInfo =>
      'Commands stay on this phone. Nothing is sent to a server.';

  @override
  String get openAndroidSettings => 'Open Android Settings';

  @override
  String get readyHeadline => 'Your alarm is ready.';

  @override
  String get readyBody => 'Commands will be sent to';

  @override
  String get chooseBackupLock => 'Choose a PIN or a pattern as a backup lock.';

  @override
  String get choosePinLength => 'Choose a 4 to 6 digit PIN.';

  @override
  String get sendingCommand => 'Sending command...';

  @override
  String get activationSent => 'Activation command sent.';

  @override
  String get deactivationSent => 'Deactivation command sent.';

  @override
  String get commandSent => 'Command sent';

  @override
  String get pleaseTryAgain => 'Please try again.';

  @override
  String get couldNotSendCommand => 'Could not send the command.';

  @override
  String get simPermissionNeeded =>
      'Phone permission is needed to choose a SIM card.';

  @override
  String get biometricReasonUnlock => 'Unlock SecureHome';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get immediately => 'Immediately';

  @override
  String seconds(int count) {
    return '$count seconds';
  }

  @override
  String get oneMinute => '1 minute';

  @override
  String get fiveMinutes => '5 minutes';

  @override
  String get backspace => 'Backspace';
}
