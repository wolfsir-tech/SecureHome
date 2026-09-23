// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appName => 'SecureHome';

  @override
  String get tagline => 'امنیت خانه، به ساده‌ترین شکل.';

  @override
  String get welcomeHeadline => 'خانه‌تان را ایمن کنید. به سادگی.';

  @override
  String get welcomeBody =>
      'SecureHome دستورات را از طریق پیامک به مرکز اعلام حریق GSM شما می‌فرستد. بدون فضای ابری، بدون حساب کاربری. فقط همین گوشی و سیم‌کارتی که داخل دستگاه قرار دارد.';

  @override
  String get getStarted => 'شروع کنید';

  @override
  String get enterApp => 'ورود به SecureHome';

  @override
  String get continueButton => 'ادامه';

  @override
  String get notNow => 'الالان نه';

  @override
  String get skipForNow => 'فعلاً رد شو';

  @override
  String get cancel => 'انصراف';

  @override
  String get close => 'بستن';

  @override
  String get save => 'ذخیره';

  @override
  String get reset => 'بازنشانی';

  @override
  String get clear => 'پاک کردن';

  @override
  String get navHome => 'خانه';

  @override
  String get navHistory => 'تاریخچه';

  @override
  String get navSettings => 'تنظیمات';

  @override
  String get alarmPhoneLabel => 'شماره تلفن دستگاه';

  @override
  String get alarmPhoneHint => 'شماره سیم‌کارت داخل دستگاه را وارد کنید.';

  @override
  String get alarmPhoneExample => '+98 912 123 4567';

  @override
  String get notSet => 'تنظیم نشده';

  @override
  String get invalidAlarmPhone => 'شماره تلفن دستگاه نامعتبر است.';

  @override
  String get armAlarm => 'فعال‌سازی';

  @override
  String get disarmAlarm => 'غیرفعال‌سازی';

  @override
  String get activate => 'فعال کن';

  @override
  String get disableAlarm => 'غیرفعال کردن دستگاه';

  @override
  String get armConfirmTitle => 'فعال شود؟';

  @override
  String get armConfirmMessage =>
      'یک پیامک حاوی دستور فعال‌سازی به دستگاه ارسال می‌شود.';

  @override
  String get disarmConfirmTitle => 'غیرفعال شود؟';

  @override
  String get disarmConfirmMessage =>
      'آیا از ارسال دستور غیرفعال‌سازی مطمئن هستید؟';

  @override
  String get biometricReasonArm => 'تأیید این دستور';

  @override
  String get commandCancelled => 'ARB_PLACEHOLDER_TOKEN_1';

  @override
  String get recentActivity => 'فعالیت‌های اخیر';

  @override
  String get noCommandsYet => 'هنوز دستوری ثبت نشده است.';

  @override
  String lastCommandAt(String time) {
    return 'آخرین دستور: $time';
  }

  @override
  String get alarmArmed => 'دستگاه فعال شد';

  @override
  String get alarmDisarmed => 'دستگاه غیرفعال شد';

  @override
  String get statusSecuredTitle => 'خانه ایمن است';

  @override
  String get statusSecuredSubtitle => 'دستگاه فعال است';

  @override
  String get statusDisarmedTitle => 'دستگاه غیرفعال';

  @override
  String get statusDisarmedSubtitle => 'دستگاه غیرفعال است';

  @override
  String get statusActivatingTitle => 'در حال فعال‌سازی';

  @override
  String get statusDeactivatingTitle => 'در حال غیرفعال‌سازی';

  @override
  String get statusSendingTitle => 'در حال ارسال پیامک';

  @override
  String get statusSendingSubtitle => 'در حال ارسال دستور...';

  @override
  String get statusErrorTitle => 'خطا';

  @override
  String get statusErrorSubtitle => 'ارسال دستور ناموفق بود';

  @override
  String get statusUnknownTitle => 'وضعیت نامشخص';

  @override
  String get statusUnknownSubtitle => 'وضعیت دستگاه نامشخص است';

  @override
  String get statusSendingSemantic => 'در حال ارسال دستور';

  @override
  String get statusUnknownSemantic => 'وضعیت دستگاه نامشخصص است';

  @override
  String get settingsTitle => 'تنظیمات';

  @override
  String get securitySection => 'امنیت';

  @override
  String get appearanceSection => 'ظاهر';

  @override
  String get alarmSection => 'دستگاه';

  @override
  String get applicationSection => 'برنامه';

  @override
  String get changePin => 'تغییر رمز';

  @override
  String get changePattern => 'تغییر الگو';

  @override
  String get fingerprint => 'اثر انگشت';

  @override
  String get unlockBiometricFirst => 'ابتدا با اثر انگشت باز کنید';

  @override
  String get biometricReasonEnable => 'فعال‌سازی باز کردن با اثر انگشت';

  @override
  String get confirmActionsBiometric => 'تأیید عملیات‌ها با اثر انگشت';

  @override
  String get autoLock => 'قفل خودکار';

  @override
  String get testSms => 'تست پیامک';

  @override
  String get checking => 'در حال بررسی...';

  @override
  String get smsSim => 'سیم‌کارت پیامک';

  @override
  String get theme => 'پوسته';

  @override
  String get about => 'درباره برنامه';

  @override
  String version(String version) {
    return 'نسخه $version';
  }

  @override
  String get resetApplication => 'بازنشانی برنامه';

  @override
  String get lightMode => 'حالت روشن';

  @override
  String get darkMode => 'حالت تیره';

  @override
  String get systemDefault => 'پیش‌فرض سیستم';

  @override
  String get defaultSim => 'سیم‌کارت پیش‌فرض';

  @override
  String get askSystemDefault => 'پرسیدن از سیستم';

  @override
  String simCard(int id) {
    return 'سیم‌کارت $id';
  }

  @override
  String get insertSim => 'لطفاً یک سیم‌کارت قرار دهید.';

  @override
  String get checkSimCard => 'سیم‌کارت خود را بررسی کنید';

  @override
  String get readyToSend => 'آماده ارسال دستورات.';

  @override
  String get resetConfirmTitle => 'بازنشانی برنامه؟';

  @override
  String get resetConfirmMessage =>
      'این کار شماره دستگاه، قفل و تاریخچه روی این گوشی را پاک می‌کند.';

  @override
  String get language => 'زبان';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePersian => 'فارسی';

  @override
  String get themeAndLanguage => 'پوسته و زبان';

  @override
  String get confirmIdentity => 'هویت خود را تأیید کنید';

  @override
  String get chooseNewPin => 'یک رمز جدید انتخاب کنید';

  @override
  String get drawNewPattern => 'یک الگوی جدید بکشید';

  @override
  String get confirmNewPin => 'رمز جدید را تأیید کنید';

  @override
  String get confirmNewPattern => 'الگوی جدید را تأیید کنید';

  @override
  String get savePin => 'ذخیره رمز AppLocalizations';

  @override
  String get noMatch => 'همخوانی نداشت. دوباره امتحان کنید.';

  @override
  String get pinsNoMatch => 'این رمزها همخوانی ندارند.';

  @override
  String get patternsNoMatch => 'این الگوها همخوانی ندارند.';

  @override
  String get patternTooShort => 'حداقل ۴ نقطه را به هم وصل کنید.';

  @override
  String get changePhoneAuthReason => 'برای تغییر شماره دستگاه تأیید لازم است';

  @override
  String get changePhoneGateMessage =>
      'تغییر شماره دستگاه نیازمند تأیید هویت است.';

  @override
  String get useFingerprint => 'استفاده از اثر انگشت';

  @override
  String get changeAlarmPhone => 'تغییر شماره تلفن دستگاه';

  @override
  String get useSimCardNumber => 'از شماره سیم‌کارت داخل دستگاه استفاده کنید.';

  @override
  String get saveNumber => 'ذخیره شماره';

  @override
  String get aboutTitle => 'درباره برنامه';

  @override
  String get privacyTitle => 'اطلاعات حریم خصوصی';

  @override
  String get privacyBody =>
      'SecureHome کاملاً روی همین گوشی کار می‌کند. هیچ حساب کاربری نمی‌سازد و با هیچ سروری ارتباط برقرار نمی‌کند. دستورات به‌صورت پیامک به شماره‌ای که ذخیره کرده‌اید ارسال می‌شوند. رمز و الگوی شما فقط به‌صورت درهم‌سازی یک‌طرفه در فضای امن ذخیره می‌شوند.';

  @override
  String get historyTitle => 'تاریخچه';

  @override
  String get clearHistoryTitle => 'پاک کردن تاریخچه؟';

  @override
  String get clearHistoryMessage =>
      'این کار فقط رکوردهای محلی دستورات را پاک می‌کند.';

  @override
  String get lockTitle => 'باز کردن SecureHome';

  @override
  String get lockBiometricHint => 'از اثر انگشت خود استفاده کنید';

  @override
  String get lockPinHint => 'رمز خود را وارد کنید';

  @override
  String get lockPatternHint => 'الگوی خود را بکشید';

  @override
  String get usePin => 'استفاده از رمز';

  @override
  String get usePattern => 'استفاده از الگو';

  @override
  String tooManyAttempts(int seconds) {
    return 'تلاش‌های زیادی انجام شد. $seconds ثانیه دیگر امتحان کنید.';
  }

  @override
  String get createPinTitle => 'یک رمز انتخاب کنید';

  @override
  String get confirmPinTitle => 'رمز خود را تأیید کنید';

  @override
  String get pinSubtitle =>
      '۴ تا ۶ رقم. این رمز SecureHome را قفل نگه می‌دارد.';

  @override
  String get drawPatternTitle => 'یک الگوی جدید بکشید';

  @override
  String get confirmPatternTitle => 'الگوی خود را تأیید کنید';

  @override
  String get numericPin => 'رمز عددی';

  @override
  String get numericPinDesc => 'یک کد ۴ تا ۶ رقمی';

  @override
  String get patternLock => 'قفل الگو';

  @override
  String get connectFourDots => 'حداقل ۴ نقطه را به هم وصل کنید';

  @override
  String get biometricNotAvailable => 'روی این گوشی در دسترس نیست';

  @override
  String get lockMethodsTitle => 'قفل کردن SecureHome';

  @override
  String get lockMethodsBody =>
      'نحوه باز کردن برنامه را انتخاب کنید. رمز یا الگو الزامی است.';

  @override
  String get biometricStepTitle => 'استفاده از اثر انگشت';

  @override
  String get biometricStepBody =>
      'با اثر انگشتی که روی همین گوشی ثبت شده، سریع‌تر وارد شوید.';

  @override
  String get biometricStepBodyUnavailable =>
      'اثر انگشت روی این گوشی در دسترس نیست.';

  @override
  String get enableFingerprint => 'فعال‌سازی اثر انگشت';

  @override
  String get biometricNotVerified => 'اثر انگشت تأیید نشد.';

  @override
  String get allowSmsTitle => 'اجازه پیامک';

  @override
  String get allowSmsBody =>
      'SecureHome برای ارسال دستورات به دستگاه به دسترسی پیامک نیاز دارد.';

  @override
  String get allowSmsInfo =>
      'دستورات روی همین گوشی می‌مانند و چیزی به سرور ارسال نمی‌شود.';

  @override
  String get openAndroidSettings => 'باز کردن تنظیمات اندروید';

  @override
  String get readyHeadline => 'دستگاه شما آماده است.';

  @override
  String get readyBody => 'دستورات ارسال خواهند شد به';

  @override
  String get chooseBackupLock =>
      'یک رمز یا الگو به‌عنوان قفل پشتیبان انتخاب کنید.';

  @override
  String get choosePinLength => 'یک رمز ۴ تا ۶ رقمی انتخاب کنید.';

  @override
  String get sendingCommand => 'در حال ارسال دستور...';

  @override
  String get activationSent => 'دستور فعال‌سازی ارسال شد.';

  @override
  String get deactivationSent => 'دستور غیرفعال‌سازی ارسال شد.';

  @override
  String get commandSent => 'دستور ارسال شد';

  @override
  String get pleaseTryAgain => 'لطفاً دوباره امتحان کنید.';

  @override
  String get couldNotSendCommand => 'ارسال دستور ممکن نشد.';

  @override
  String get simPermissionNeeded =>
      'برای انتخاب سیم‌کارت به دسترسی تلفن نیاز است.';

  @override
  String get biometricReasonUnlock => 'باز کردن SecureHome';

  @override
  String get today => 'امروز';

  @override
  String get yesterday => 'دیروز';

  @override
  String get immediately => 'بلافاصله';

  @override
  String seconds(int count) {
    return '$count ثانیه';
  }

  @override
  String get oneMinute => '۱ دقیقه';

  @override
  String get fiveMinutes => '۵ دقیقه';

  @override
  String get backspace => 'پاک‌کن';
}
