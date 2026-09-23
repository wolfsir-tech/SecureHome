import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SecureHome'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Home security, simply.'**
  String get tagline;

  /// No description provided for @welcomeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Protect your home. Simply.'**
  String get welcomeHeadline;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'SecureHome sends SMS commands to your GSM alarm. No cloud. No account. Just this device and your alarm SIM.'**
  String get welcomeBody;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @enterApp.
  ///
  /// In en, this message translates to:
  /// **'Enter SecureHome'**
  String get enterApp;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @alarmPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Alarm phone number'**
  String get alarmPhoneLabel;

  /// No description provided for @alarmPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the SIM card number inside your alarm system.'**
  String get alarmPhoneHint;

  /// No description provided for @alarmPhoneExample.
  ///
  /// In en, this message translates to:
  /// **'+98 912 123 4567'**
  String get alarmPhoneExample;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @invalidAlarmPhone.
  ///
  /// In en, this message translates to:
  /// **'The alarm phone number is invalid.'**
  String get invalidAlarmPhone;

  /// No description provided for @armAlarm.
  ///
  /// In en, this message translates to:
  /// **'ARM ALARM'**
  String get armAlarm;

  /// No description provided for @disarmAlarm.
  ///
  /// In en, this message translates to:
  /// **'DISARM'**
  String get disarmAlarm;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @disableAlarm.
  ///
  /// In en, this message translates to:
  /// **'Disable Alarm'**
  String get disableAlarm;

  /// No description provided for @armConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate home alarm?'**
  String get armConfirmTitle;

  /// No description provided for @armConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'An SMS command will be sent to the alarm system.'**
  String get armConfirmMessage;

  /// No description provided for @disarmConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable home alarm?'**
  String get disarmConfirmTitle;

  /// No description provided for @disarmConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to send the deactivation command?'**
  String get disarmConfirmMessage;

  /// No description provided for @biometricReasonArm.
  ///
  /// In en, this message translates to:
  /// **'Confirm this alarm command'**
  String get biometricReasonArm;

  /// No description provided for @commandCancelled.
  ///
  /// In en, this message translates to:
  /// **'Command cancelled.'**
  String get commandCancelled;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @noCommandsYet.
  ///
  /// In en, this message translates to:
  /// **'No commands yet.'**
  String get noCommandsYet;

  /// No description provided for @lastCommandAt.
  ///
  /// In en, this message translates to:
  /// **'Last command {time}'**
  String lastCommandAt(String time);

  /// No description provided for @alarmArmed.
  ///
  /// In en, this message translates to:
  /// **'Alarm armed'**
  String get alarmArmed;

  /// No description provided for @alarmDisarmed.
  ///
  /// In en, this message translates to:
  /// **'Alarm disarmed'**
  String get alarmDisarmed;

  /// No description provided for @statusSecuredTitle.
  ///
  /// In en, this message translates to:
  /// **'HOME SECURED'**
  String get statusSecuredTitle;

  /// No description provided for @statusSecuredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Home is secured'**
  String get statusSecuredSubtitle;

  /// No description provided for @statusDisarmedTitle.
  ///
  /// In en, this message translates to:
  /// **'ALARM DISARMED'**
  String get statusDisarmedTitle;

  /// No description provided for @statusDisarmedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Alarm is disarmed'**
  String get statusDisarmedSubtitle;

  /// No description provided for @statusActivatingTitle.
  ///
  /// In en, this message translates to:
  /// **'ACTIVATING'**
  String get statusActivatingTitle;

  /// No description provided for @statusDeactivatingTitle.
  ///
  /// In en, this message translates to:
  /// **'DEACTIVATING'**
  String get statusDeactivatingTitle;

  /// No description provided for @statusSendingTitle.
  ///
  /// In en, this message translates to:
  /// **'SENDING SMS'**
  String get statusSendingTitle;

  /// No description provided for @statusSendingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sending command...'**
  String get statusSendingSubtitle;

  /// No description provided for @statusErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'ERROR'**
  String get statusErrorTitle;

  /// No description provided for @statusErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to send command'**
  String get statusErrorSubtitle;

  /// No description provided for @statusUnknownTitle.
  ///
  /// In en, this message translates to:
  /// **'STATUS UNKNOWN'**
  String get statusUnknownTitle;

  /// No description provided for @statusUnknownSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send a command to update status'**
  String get statusUnknownSubtitle;

  /// No description provided for @statusSendingSemantic.
  ///
  /// In en, this message translates to:
  /// **'Sending command'**
  String get statusSendingSemantic;

  /// No description provided for @statusUnknownSemantic.
  ///
  /// In en, this message translates to:
  /// **'Alarm status unknown'**
  String get statusUnknownSemantic;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @securitySection.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securitySection;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @alarmSection.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get alarmSection;

  /// No description provided for @applicationSection.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get applicationSection;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @changePattern.
  ///
  /// In en, this message translates to:
  /// **'Change pattern'**
  String get changePattern;

  /// No description provided for @fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get fingerprint;

  /// No description provided for @unlockBiometricFirst.
  ///
  /// In en, this message translates to:
  /// **'Unlock with biometrics first'**
  String get unlockBiometricFirst;

  /// No description provided for @biometricReasonEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable fingerprint unlock'**
  String get biometricReasonEnable;

  /// No description provided for @confirmActionsBiometric.
  ///
  /// In en, this message translates to:
  /// **'Confirm actions with fingerprint'**
  String get confirmActionsBiometric;

  /// No description provided for @autoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock'**
  String get autoLock;

  /// No description provided for @testSms.
  ///
  /// In en, this message translates to:
  /// **'Test SMS'**
  String get testSms;

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checking;

  /// No description provided for @smsSim.
  ///
  /// In en, this message translates to:
  /// **'SMS SIM'**
  String get smsSim;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @resetApplication.
  ///
  /// In en, this message translates to:
  /// **'Reset application'**
  String get resetApplication;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @defaultSim.
  ///
  /// In en, this message translates to:
  /// **'Default SIM'**
  String get defaultSim;

  /// No description provided for @askSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'Ask system default'**
  String get askSystemDefault;

  /// No description provided for @simCard.
  ///
  /// In en, this message translates to:
  /// **'SIM {id}'**
  String simCard(int id);

  /// No description provided for @insertSim.
  ///
  /// In en, this message translates to:
  /// **'Please insert a SIM card.'**
  String get insertSim;

  /// No description provided for @checkSimCard.
  ///
  /// In en, this message translates to:
  /// **'Check your SIM card'**
  String get checkSimCard;

  /// No description provided for @readyToSend.
  ///
  /// In en, this message translates to:
  /// **'Ready to send commands.'**
  String get readyToSend;

  /// No description provided for @resetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset application?'**
  String get resetConfirmTitle;

  /// No description provided for @resetConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This erases the alarm number, lock, and history on this device.'**
  String get resetConfirmMessage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePersian.
  ///
  /// In en, this message translates to:
  /// **'فارسی'**
  String get languagePersian;

  /// No description provided for @themeAndLanguage.
  ///
  /// In en, this message translates to:
  /// **'Theme & language'**
  String get themeAndLanguage;

  /// No description provided for @confirmIdentity.
  ///
  /// In en, this message translates to:
  /// **'Confirm it is you'**
  String get confirmIdentity;

  /// No description provided for @chooseNewPin.
  ///
  /// In en, this message translates to:
  /// **'Choose a new PIN'**
  String get chooseNewPin;

  /// No description provided for @drawNewPattern.
  ///
  /// In en, this message translates to:
  /// **'Draw a new pattern'**
  String get drawNewPattern;

  /// No description provided for @confirmNewPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new PIN'**
  String get confirmNewPin;

  /// No description provided for @confirmNewPattern.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new pattern'**
  String get confirmNewPattern;

  /// No description provided for @savePin.
  ///
  /// In en, this message translates to:
  /// **'Save PIN'**
  String get savePin;

  /// No description provided for @noMatch.
  ///
  /// In en, this message translates to:
  /// **'That did not match. Try again.'**
  String get noMatch;

  /// No description provided for @pinsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Those PINs did not match.'**
  String get pinsNoMatch;

  /// No description provided for @patternsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Those patterns did not match.'**
  String get patternsNoMatch;

  /// No description provided for @patternTooShort.
  ///
  /// In en, this message translates to:
  /// **'Connect at least 4 dots.'**
  String get patternTooShort;

  /// No description provided for @changePhoneAuthReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm to change the alarm number'**
  String get changePhoneAuthReason;

  /// No description provided for @changePhoneGateMessage.
  ///
  /// In en, this message translates to:
  /// **'Changing the alarm number requires authentication.'**
  String get changePhoneGateMessage;

  /// No description provided for @useFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint'**
  String get useFingerprint;

  /// No description provided for @changeAlarmPhone.
  ///
  /// In en, this message translates to:
  /// **'Change alarm phone number'**
  String get changeAlarmPhone;

  /// No description provided for @useSimCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Use the SIM card number inside the alarm.'**
  String get useSimCardNumber;

  /// No description provided for @saveNumber.
  ///
  /// In en, this message translates to:
  /// **'Save number'**
  String get saveNumber;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy information'**
  String get privacyTitle;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'SecureHome works entirely on this device. It does not create an account and does not talk to a server. Alarm commands are sent as SMS to the number you save. Your PIN and pattern are stored only as one-way hashes in secure storage.'**
  String get privacyBody;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @clearHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear history?'**
  String get clearHistoryTitle;

  /// No description provided for @clearHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'This only removes local command records.'**
  String get clearHistoryMessage;

  /// No description provided for @lockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock SecureHome'**
  String get lockTitle;

  /// No description provided for @lockBiometricHint.
  ///
  /// In en, this message translates to:
  /// **'Use your fingerprint'**
  String get lockBiometricHint;

  /// No description provided for @lockPinHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get lockPinHint;

  /// No description provided for @lockPatternHint.
  ///
  /// In en, this message translates to:
  /// **'Draw your pattern'**
  String get lockPatternHint;

  /// No description provided for @usePin.
  ///
  /// In en, this message translates to:
  /// **'Use PIN'**
  String get usePin;

  /// No description provided for @usePattern.
  ///
  /// In en, this message translates to:
  /// **'Use pattern'**
  String get usePattern;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {seconds}s.'**
  String tooManyAttempts(int seconds);

  /// No description provided for @createPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a PIN'**
  String get createPinTitle;

  /// No description provided for @confirmPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN'**
  String get confirmPinTitle;

  /// No description provided for @pinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'4 to 6 digits. This keeps SecureHome locked.'**
  String get pinSubtitle;

  /// No description provided for @drawPatternTitle.
  ///
  /// In en, this message translates to:
  /// **'Draw a pattern'**
  String get drawPatternTitle;

  /// No description provided for @confirmPatternTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your pattern'**
  String get confirmPatternTitle;

  /// No description provided for @numericPin.
  ///
  /// In en, this message translates to:
  /// **'Numeric PIN'**
  String get numericPin;

  /// No description provided for @numericPinDesc.
  ///
  /// In en, this message translates to:
  /// **'A 4 to 6 digit code'**
  String get numericPinDesc;

  /// No description provided for @patternLock.
  ///
  /// In en, this message translates to:
  /// **'Pattern lock'**
  String get patternLock;

  /// No description provided for @connectFourDots.
  ///
  /// In en, this message translates to:
  /// **'Connect at least 4 dots'**
  String get connectFourDots;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available on this device'**
  String get biometricNotAvailable;

  /// No description provided for @lockMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock SecureHome'**
  String get lockMethodsTitle;

  /// No description provided for @lockMethodsBody.
  ///
  /// In en, this message translates to:
  /// **'Choose how you unlock the app. A PIN or pattern is required.'**
  String get lockMethodsBody;

  /// No description provided for @biometricStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint'**
  String get biometricStepTitle;

  /// No description provided for @biometricStepBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock SecureHome faster with the fingerprint already on this device.'**
  String get biometricStepBody;

  /// No description provided for @biometricStepBodyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint is not available on this device.'**
  String get biometricStepBodyUnavailable;

  /// No description provided for @enableFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Enable fingerprint'**
  String get enableFingerprint;

  /// No description provided for @biometricNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint was not verified.'**
  String get biometricNotVerified;

  /// No description provided for @allowSmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow SMS'**
  String get allowSmsTitle;

  /// No description provided for @allowSmsBody.
  ///
  /// In en, this message translates to:
  /// **'SecureHome needs SMS permission to send commands to your alarm.'**
  String get allowSmsBody;

  /// No description provided for @allowSmsInfo.
  ///
  /// In en, this message translates to:
  /// **'Commands stay on this phone. Nothing is sent to a server.'**
  String get allowSmsInfo;

  /// No description provided for @openAndroidSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Android Settings'**
  String get openAndroidSettings;

  /// No description provided for @readyHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your alarm is ready.'**
  String get readyHeadline;

  /// No description provided for @readyBody.
  ///
  /// In en, this message translates to:
  /// **'Commands will be sent to'**
  String get readyBody;

  /// No description provided for @chooseBackupLock.
  ///
  /// In en, this message translates to:
  /// **'Choose a PIN or a pattern as a backup lock.'**
  String get chooseBackupLock;

  /// No description provided for @choosePinLength.
  ///
  /// In en, this message translates to:
  /// **'Choose a 4 to 6 digit PIN.'**
  String get choosePinLength;

  /// No description provided for @sendingCommand.
  ///
  /// In en, this message translates to:
  /// **'Sending command...'**
  String get sendingCommand;

  /// No description provided for @activationSent.
  ///
  /// In en, this message translates to:
  /// **'Activation command sent.'**
  String get activationSent;

  /// No description provided for @deactivationSent.
  ///
  /// In en, this message translates to:
  /// **'Deactivation command sent.'**
  String get deactivationSent;

  /// No description provided for @commandSent.
  ///
  /// In en, this message translates to:
  /// **'Command sent'**
  String get commandSent;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get pleaseTryAgain;

  /// No description provided for @couldNotSendCommand.
  ///
  /// In en, this message translates to:
  /// **'Could not send the command.'**
  String get couldNotSendCommand;

  /// No description provided for @simPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Phone permission is needed to choose a SIM card.'**
  String get simPermissionNeeded;

  /// No description provided for @biometricReasonUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock SecureHome'**
  String get biometricReasonUnlock;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @immediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get immediately;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'{count} seconds'**
  String seconds(int count);

  /// No description provided for @oneMinute.
  ///
  /// In en, this message translates to:
  /// **'1 minute'**
  String get oneMinute;

  /// No description provided for @fiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get fiveMinutes;

  /// No description provided for @backspace.
  ///
  /// In en, this message translates to:
  /// **'Backspace'**
  String get backspace;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
