import 'package:flutter/material.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/theme/app_shadows.dart';

/// Soft UI card. Raised neumorphic surface (Section 5) with a hairline border
/// so the shadow is never the only boundary (Section 26).
///
/// Set [interactive] when the whole card is tappable; the pressed state becomes
/// subtly inset instead of raised.
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.radius = AppRadius.card,
    this.inset = false,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final double radius;

  /// Render as a recessed (inset) surface instead of a raised one.
  final bool inset;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _pressed = false;

  bool get _interactive => widget.onTap != null;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(widget.radius);
    final recessed = widget.inset || (_interactive && _pressed);

    final body = AnimatedContainer(
      duration: AppShadows.micro,
      width: double.infinity,
      padding: widget.padding,
      decoration: BoxDecoration(
        borderRadius: radius,
        color: recessed ? null : colors.surface,
        gradient: recessed ? AppShadows.insetGradient(colors) : null,
        border: Border.all(color: colors.border),
        boxShadow: recessed ? null : AppShadows.raisedSm(colors),
      ),
      child: widget.child,
    );

    if (!_interactive) return body;
    return Semantics(
      button: true,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: widget.onTap,
        child: body,
      ),
    );
  }
}
