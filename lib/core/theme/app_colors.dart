import 'package:flutter/material.dart';

/// Ramzin Soft UI / Neumorphism 2.0 color tokens.
///
/// The palette is a cool, neutral gray-blue base with a blue-indigo accent.
/// Three surface tiers express depth:
///   [bg]            the canvas behind everything
///   [surface]       raised surfaces (cards, buttons, nav) — slightly lighter
///   [surfaceHigh]   recessed wells (inputs, tracks) — slightly darker
///
/// Text tokens are tuned to keep WCAG 2.2 AA contrast on every surface:
/// even [textMuted] stays above 4.5:1 because neumorphic surfaces are low-noise.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceHigh,
    required this.border,
    required this.accent,
    required this.accentHover,
    required this.accentMuted,
    required this.secured,
    required this.disarmed,
    required this.warning,
    required this.processing,
    required this.text,
    required this.textSecondary,
    required this.textMuted,
    required this.onAccent,
    required this.shadowDark,
    required this.shadowLight,
  });

  /// Canvas color.
  final Color bg;

  /// Raised surface (cards, buttons, navigation containers).
  final Color surface;

  /// Same tier as [surface]; explicit alias for raised elements.
  final Color surfaceRaised;

  /// Recessed surface (inputs, progress tracks, wells).
  final Color surfaceHigh;

  /// Hairline boundary. Subtle, never the only separator — used *with* shadow.
  final Color border;

  final Color accent;
  final Color accentHover;

  /// Soft accent tint for selection/active indicators.
  final Color accentMuted;

  final Color secured;
  final Color disarmed;
  final Color warning;
  final Color processing;

  final Color text;
  final Color textSecondary;
  final Color textMuted;
  final Color onAccent;

  /// Dual-direction neumorphic shadow colors: dark bottom-right, light top-left.
  final Color shadowDark;
  final Color shadowLight;

  static const dark = AppColors(
    bg: Color(0xFF20252D),
    surface: Color(0xFF252B34),
    surfaceRaised: Color(0xFF252B34),
    surfaceHigh: Color(0xFF1A1F26),
    border: Color(0x0DFFFFFF),
    accent: Color(0xFF7188FF),
    accentHover: Color(0xFF8297FF),
    accentMuted: Color(0xFF2C3550),
    secured: Color(0xFF55BD83),
    disarmed: Color(0xFFEF6B76),
    warning: Color(0xFFD7A04A),
    processing: Color(0xFF7188FF),
    text: Color(0xFFEDF1F7),
    textSecondary: Color(0xFF9AA5B4),
    textMuted: Color(0xFF8B95A3),
    onAccent: Color(0xFF0B1020),
    shadowDark: Color(0x8C0C0F14),
    shadowLight: Color(0x59323944),
  );

  static const light = AppColors(
    bg: Color(0xFFE8EDF3),
    surface: Color(0xFFEDF2F7),
    surfaceRaised: Color(0xFFEDF2F7),
    surfaceHigh: Color(0xFFDFE5EC),
    border: Color(0x59FFFFFF),
    accent: Color(0xFF4F6DF5),
    accentHover: Color(0xFF415EE0),
    accentMuted: Color(0xFFE3E9FD),
    secured: Color(0xFF36A269),
    disarmed: Color(0xFFD9535F),
    warning: Color(0xFFC58A28),
    processing: Color(0xFF4F6DF5),
    text: Color(0xFF202733),
    textSecondary: Color(0xFF4C5663),
    textMuted: Color(0xFF5C6875),
    onAccent: Color(0xFFFFFFFF),
    shadowDark: Color(0x8CA3AEBD),
    shadowLight: Color(0xE6FFFFFF),
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceHigh,
    Color? border,
    Color? accent,
    Color? accentHover,
    Color? accentMuted,
    Color? secured,
    Color? disarmed,
    Color? warning,
    Color? processing,
    Color? text,
    Color? textSecondary,
    Color? textMuted,
    Color? onAccent,
    Color? shadowDark,
    Color? shadowLight,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      border: border ?? this.border,
      accent: accent ?? this.accent,
      accentHover: accentHover ?? this.accentHover,
      accentMuted: accentMuted ?? this.accentMuted,
      secured: secured ?? this.secured,
      disarmed: disarmed ?? this.disarmed,
      warning: warning ?? this.warning,
      processing: processing ?? this.processing,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      onAccent: onAccent ?? this.onAccent,
      shadowDark: shadowDark ?? this.shadowDark,
      shadowLight: shadowLight ?? this.shadowLight,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentHover: Color.lerp(accentHover, other.accentHover, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      secured: Color.lerp(secured, other.secured, t)!,
      disarmed: Color.lerp(disarmed, other.disarmed, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      processing: Color.lerp(processing, other.processing, t)!,
      text: Color.lerp(text, other.text, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      shadowDark: Color.lerp(shadowDark, other.shadowDark, t)!,
      shadowLight: Color.lerp(shadowLight, other.shadowLight, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>() ?? AppColors.light;
}
