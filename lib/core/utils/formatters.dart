import 'package:intl/intl.dart';

class Formatters {
  static String time(DateTime dt) => DateFormat('HH:mm').format(dt.toLocal());

  static String date(DateTime dt) => DateFormat('d MMM yyyy').format(dt.toLocal());

  static String dateTime(DateTime dt) => DateFormat('d MMM · HH:mm').format(dt.toLocal());

  static String relativeDay(DateTime dt) {
    final local = dt.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return date(local);
  }

  static String autoLockLabel(Duration d) {
    if (d == Duration.zero) return 'Immediately';
    if (d.inSeconds == 30) return '30 seconds';
    if (d.inMinutes == 1) return '1 minute';
    if (d.inMinutes == 5) return '5 minutes';
    return '${d.inSeconds} seconds';
  }
}
