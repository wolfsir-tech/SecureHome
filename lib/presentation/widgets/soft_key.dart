import 'package:flutter/material.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/theme/app_shadows.dart';

/// Ramzin soft circular button — raised by default, inset while pressed.
///
/// Used for icon actions (lock, fingerprint) and, at [AppTarget.key] size, for
/// PIN keypad keys. Touch target is always >= [AppTarget.min] (Section 27).
class SoftKey extends StatefulWidget {
  const SoftKey({
    super.key,
    this.label,
    this.icon,
    this.onTap,
    this.size = AppTarget.key,
    this.color,
    this.semanticsLabel,
  });

  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;
  final double size;
  final Color? color;
  final String? semanticsLabel;

  @override
  State<SoftKey> createState() => _SoftKeyState();
}

class _SoftKeyState extends State<SoftKey> {
  bool _pressed = false;

  bool get _enabled => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final ink = widget.color ?? colors.text;

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticsLabel ?? widget.label,
      child: GestureDetector(
        onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: _enabled ? widget.onTap : null,
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: AppShadows.micro,
          child: AnimatedContainer(
            duration: AppShadows.micro,
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _pressed ? null : colors.surface,
              gradient: _pressed ? AppShadows.insetGradient(colors) : null,
              border: Border.all(color: colors.border),
              boxShadow: _pressed ? null : AppShadows.raisedSm(colors),
            ),
            child: Center(
              child: widget.icon != null
                  ? Icon(widget.icon, color: ink, size: widget.size * 0.32)
                  : Text(
                      widget.label ?? '',
                      style: TextStyle(
                        fontFamily: theme.textTheme.titleLarge?.fontFamily,
                        fontSize: widget.size * 0.36,
                        fontWeight: FontWeight.w500,
                        color: ink,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
