import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/theme/app_shadows.dart';
import 'package:secure_home/core/theme/app_theme.dart';

/// Ramzin primary button (Section 13).
///
/// default   -> raised soft surface with a subtle accent tint
/// hover     -> lifts 1px
/// pressed   -> becomes inset (pressed into the surface)
/// focus     -> 3px accent outline (never shadow-only focus)
/// disabled  -> reduced opacity, clearly distinguishable from enabled
/// loading   -> spinner replaces the label, input ignored
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.foreground,
    this.loading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? foreground;
  final bool loading;
  final bool enabled;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.enabled && !widget.loading && widget.onPressed != null;

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final isEnter = event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space;
    if (!isEnter || !_enabled) return KeyEventResult.ignored;
    if (event is KeyDownEvent) {
      HapticFeedback.lightImpact();
      widget.onPressed?.call();
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = widget.color ?? colors.accent;
    final onAccent = widget.foreground ?? colors.onAccent;

    return Focus(
      onFocusChange: (value) => setState(() => _focused = value),
      onKeyEvent: _onKey,
      canRequestFocus: _enabled,
      child: Semantics(
        button: true,
        enabled: _enabled,
        label: widget.label,
        child: GestureDetector(
          onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          onTap: _enabled
              ? () {
                  HapticFeedback.lightImpact();
                  widget.onPressed?.call();
                }
              : null,
          child: AnimatedScale(
            scale: _pressed ? 0.985 : 1.0,
            duration: AppShadows.micro,
            child: AnimatedOpacity(
              duration: AppShadows.normal,
              opacity: _enabled ? 1 : 0.45,
              child: Container(
                // Section 13: focus is communicated by an outline, never by
                // shadow alone. The ring sits outside the button surface.
                padding: EdgeInsets.all(_focused ? 4 : 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.button + 4),
                  border: _focused
                      ? Border.all(
                          color: colors.accent.withValues(alpha: 0.55),
                          width: 3,
                        )
                      : null,
                ),
                child: AnimatedContainer(
                  duration: AppShadows.micro,
                  height: AppTarget.button,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    color: _pressed ? null : accent,
                    gradient: _pressed
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.lerp(accent, colors.shadowDark, 0.30)!,
                              Color.lerp(accent, colors.shadowLight, 0.14)!,
                            ],
                          )
                        : null,
                    border: Border.all(
                      color: colors.border.withValues(alpha: _enabled ? 0.9 : 0.4),
                    ),
                    boxShadow: _pressed ? null : AppShadows.raisedSm(colors),
                  ),
                  alignment: Alignment.center,
                  child: widget.loading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: onAccent,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon, color: onAccent),
                              const SizedBox(width: 10),
                            ],
                            Text(
                              widget.label,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: onAccent,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', widget.label));
    properties.add(FlagProperty('loading', value: widget.loading, ifFalse: 'idle'));
  }
}

/// Ghost button — flat, quiet secondary action (Section 38: tertiary tier).
class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: color ?? colors.text,
            side: BorderSide(color: colors.border),
            surfaceTintColor: Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: color ?? colors.text),
                const SizedBox(width: 10),
              ],
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
