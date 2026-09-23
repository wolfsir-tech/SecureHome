import 'package:intl/intl.dart';
import 'package:secure_home/l10n/generated/app_localizations.dart';

class Formatters {
  static String time(DateTime dt) => DateFormat('HH:mm').format(dt.toLocal());

  static String date(DateTime dt) => DateFormat('d MMM yyyy').format(dt.toLocal());

  static String dateTime(DateTime dt) => DateFormat('d MMM · HH:mm').format(dt.toLocal());

  static String relativeDay(DateTime dt, [AppLocalizations? l10n]) {
    final local = dt.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return l10n?.today ?? 'Today';
    if (diff == 1) return l10n?.yesterday ?? 'Yesterday';
    return date(local);
  }

  static String autoLockLabel(Duration d, [AppLocalizations? l10n]) {
    if (d == Duration.zero) return l10n?.immediately ?? 'Immediately';
    if (d.inSeconds == 30) return l10n?.seconds(30) ?? '30 seconds';
    if (d.inMinutes == 1) return l10n?.oneMinute ?? '1 minute';
    if (d.inMinutes == 5) return l10n?.fiveMinutes ?? '5 minutes';
    return l10n?.seconds(d.inSeconds) ?? '${d.inSeconds} seconds';
  }
}
