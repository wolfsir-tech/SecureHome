import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.surfaceHigh,
    required this.border,
    required this.accent,
    required this.accentMuted,
    required this.secured,
    required this.disarmed,
    required this.warning,
    required this.processing,
    required this.text,
    required this.textMuted,
    required this.onAccent,
  });

  final Color bg;
  final Color surface;
  final Color surfaceHigh;
  final Color border;
  final Color accent;
  final Color accentMuted;
  final Color secured;
  final Color disarmed;
  final Color warning;
  final Color processing;
  final Color text;
  final Color textMuted;
  final Color onAccent;

  static const dark = AppColors(
    bg: Color(0xFF07080A),
    surface: Color(0xFF111318),
    surfaceHigh: Color(0xFF1A1E26),
    border: Color(0xFF2A303A),
    accent: Color(0xFF3EE0FF),
    accentMuted: Color(0xFF164A55),
    secured: Color(0xFF3DDC97),
    disarmed: Color(0xFFFF5A5A),
    warning: Color(0xFFFFB020),
    processing: Color(0xFF4C8DFF),
    text: Color(0xFFF4F6F8),
    textMuted: Color(0xFF8B93A1),
    onAccent: Color(0xFF041114),
  );

  static const light = AppColors(
    bg: Color(0xFFF3F5F8),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFEAEEF3),
    border: Color(0xFFD4DBE4),
    accent: Color(0xFF067A86),
    accentMuted: Color(0xFFD4F4F8),
    secured: Color(0xFF0B9F6E),
    disarmed: Color(0xFFD92D20),
    warning: Color(0xFFB54708),
    processing: Color(0xFF155EEF),
    text: Color(0xFF101828),
    textMuted: Color(0xFF667085),
    onAccent: Color(0xFFFFFFFF),
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceHigh,
    Color? border,
    Color? accent,
    Color? accentMuted,
    Color? secured,
    Color? disarmed,
    Color? warning,
    Color? processing,
    Color? text,
    Color? textMuted,
    Color? onAccent,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      border: border ?? this.border,
      accent: accent ?? this.accent,
      accentMuted: accentMuted ?? this.accentMuted,
      secured: secured ?? this.secured,
      disarmed: disarmed ?? this.disarmed,
      warning: warning ?? this.warning,
      processing: processing ?? this.processing,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      onAccent: onAccent ?? this.onAccent,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      secured: Color.lerp(secured, other.secured, t)!,
      disarmed: Color.lerp(disarmed, other.disarmed, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      processing: Color.lerp(processing, other.processing, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>() ?? AppColors.dark;
}
