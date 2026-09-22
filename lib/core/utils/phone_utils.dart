class PhoneUtils {
  static final _e164 = RegExp(r'^\+[1-9]\d{7,14}$');

  static String digitsAndPlus(String input) {
    return input.replaceAll(RegExp(r'[^\d+]'), '');
  }

  static String? normalize(String input) {
    var value = digitsAndPlus(input.trim());
    if (value.isEmpty) return null;
    if (value.startsWith('00')) {
      value = '+${value.substring(2)}';
    }
    if (!value.startsWith('+')) {
      if (value.startsWith('09') && value.length == 11) {
        value = '+98${value.substring(1)}';
      } else if (value.startsWith('9') && value.length == 10) {
        value = '+98$value';
      } else {
        value = '+$value';
      }
    }
    if (!_e164.hasMatch(value)) return null;
    return value;
  }

  static bool isValid(String input) => normalize(input) != null;

  /// Example: +989121234567 → +98 *** *** 4567
  static String mask(String e164) {
    final normalized = normalize(e164) ?? e164;
    if (!normalized.startsWith('+') || normalized.length < 8) return '***';
    final digits = normalized.substring(1);
    final last4 = digits.substring(digits.length - 4);
    final ccLen = _countryCodeLength(digits);
    final cc = digits.substring(0, ccLen);
    return '+$cc *** *** $last4';
  }

  static int _countryCodeLength(String digits) {
    if (digits.startsWith('1')) return 1;
    if (digits.startsWith('7')) return 1;
    if (digits.startsWith('98') ||
        digits.startsWith('44') ||
        digits.startsWith('49') ||
        digits.startsWith('33') ||
        digits.startsWith('39') ||
        digits.startsWith('90') ||
        digits.startsWith('86') ||
        digits.startsWith('81') ||
        digits.startsWith('82') ||
        digits.startsWith('91')) {
      return 2;
    }
    return digits.length >= 12 ? 2 : 2;
  }
}
