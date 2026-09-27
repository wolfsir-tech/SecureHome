import 'package:flutter/material.dart';
import 'package:secure_home/core/theme/app_colors.dart';

/// Ramzin Soft UI geometry tokens.
///
/// Radius scale (Section 6), 8px spacing scale (Section 7) and the
/// dual-direction neumorphic shadow system (Section 5).
///
/// RULE (Section 5): strong neumorphic shadows are not applied to every element.
///   raised    -> cards, primary buttons, navigation containers, plinths
///   raisedSm  -> smaller controls, chips, keypad keys, icon buttons
///   inset     -> search fields, text inputs, PIN inputs, progress tracks, wells
///   flat      -> secondary text, metadata, table content, small utilities
class AppRadius {
  AppRadius._();

  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 22;
  static const double xl = 28;
  static const double pill = 999;

  /// Inputs (Section 6: 14–16px).
  static const double input = 16;

  /// Buttons (Section 6: 14–18px).
  static const double button = 16;

  /// Cards (Section 6: 20–24px).
  static const double card = 22;

  /// Main containers (Section 6: 24–28px).
  static const double container = 28;
}

class AppSpacing {
  AppSpacing._();

  static const double micro = 4; // micro
  static const double xs = 8; // xs
  static const double sm = 12; // sm
  static const double md = 16; // md
  static const double lg = 20; // lg
  static const double xl = 24; // xl
  static const double xxl = 32; // 2xl
  static const double xxxl = 40; // 3xl
  static const double huge = 48; // 4xl
  static const double section = 64; // section
}

/// Comfortable touch target floor (Section 27: ~44px or larger).
class AppTarget {
  AppTarget._();

  static const double min = 44;
  static const double button = 56;
  static const double key = 76;
}

class AppShadows {
  AppShadows._();

  /// Raised shadow for cards, primary buttons, navigation containers.
  static List<BoxShadow> raised(AppColors c) => [
        BoxShadow(
          color: c.shadowDark,
          offset: const Offset(10, 10),
          blurRadius: 22,
        ),
        BoxShadow(
          color: c.shadowLight,
          offset: const Offset(-10, -10),
          blurRadius: 22,
        ),
      ];

  /// Smaller raised shadow for controls, chips, keypad keys, icon buttons.
  static List<BoxShadow> raisedSm(AppColors c) => [
        BoxShadow(
          color: c.shadowDark.withValues(alpha: 0.82),
          offset: const Offset(5, 5),
          blurRadius: 12,
        ),
        BoxShadow(
          color: c.shadowLight.withValues(alpha: 0.89),
          offset: const Offset(-5, -5),
          blurRadius: 12,
        ),
      ];

  /// Recessed gradient for inputs, wells, progress tracks, pressed surfaces.
  ///
  /// A pressed-in surface is darker at the top-left inner edge and lighter at
  /// the bottom-right, so the gradient runs dark -> light diagonally.
  static LinearGradient insetGradient(AppColors c) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(c.surfaceHigh, c.shadowDark, 0.32)!,
          Color.lerp(c.surfaceHigh, c.shadowLight, 0.18)!,
        ],
      );

  /// Raised gradient (light top-left -> dark bottom-right) for elements that
  /// need a convex feel without a real drop shadow.
  static LinearGradient raisedGradient(AppColors c) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(c.surface, c.shadowLight, 0.25)!,
          Color.lerp(c.surface, c.shadowDark, 0.18)!,
        ],
      );

  /// Motion durations (Section 25): micro 120–160ms, normal 160–220ms.
  static const Duration micro = Duration(milliseconds: 140);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration complex = Duration(milliseconds: 280);
}

/// Neumorphic surface container — raised by default, inset when [inset].
///
/// Keeps a hairline [AppColors.border] alongside the shadow so that shadow is
/// never the only boundary (Section 26 accessibility rule).
class SoftSurface extends StatelessWidget {
  const SoftSurface({
    super.key,
    required this.child,
    this.radius = AppRadius.card,
    this.inset = false,
    this.raised = true,
    this.padding = EdgeInsets.zero,
    this.shape = BoxShape.rectangle,
  });

  final Widget child;
  final double radius;
  final bool inset;

  /// When true (and [inset] is false) a raised drop shadow is applied.
  final bool raised;
  final EdgeInsets padding;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderRadius = shape == BoxShape.circle ? null : BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        shape: shape,
        gradient: inset ? AppShadows.insetGradient(colors) : null,
        color: inset ? null : colors.surface,
        border: Border.all(color: colors.border),
        boxShadow: !inset && raised ? AppShadows.raisedSm(colors) : null,
      ),
      child: padding == EdgeInsets.zero ? child : Padding(padding: padding, child: child),
    );
  }
}
