import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/theme/app_shadows.dart';
import 'package:secure_home/l10n/l10n.dart';
import 'package:secure_home/presentation/widgets/soft_key.dart';

class PinKeypad extends StatelessWidget {
  const PinKeypad({
    super.key,
    required this.length,
    required this.maxLength,
    required this.onDigit,
    required this.onBackspace,
    this.onBiometric,
    this.error = false,
    this.obscure = true,
  });

  final int length;
  final int maxLength;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback? onBiometric;
  final bool error;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        _Dots(
          length: length,
          maxLength: maxLength,
          error: error,
          color: error ? colors.disarmed : colors.accent,
          muted: colors.textMuted,
        ),
        const SizedBox(height: 28),
        for (final row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row
                  .map(
                    (d) => SoftKey(
                      label: d,
                      semanticsLabel: d,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onDigit(d);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SoftKey(
              icon: onBiometric == null ? null : Icons.fingerprint_rounded,
              onTap: onBiometric,
              semanticsLabel: onBiometric == null ? '' : context.l10n.fingerprint,
              color: onBiometric == null ? colors.textMuted : colors.accent,
            ),
            SoftKey(
              label: '0',
              semanticsLabel: '0',
              onTap: () {
                HapticFeedback.selectionClick();
                onDigit('0');
              },
            ),
            SoftKey(
              icon: Icons.backspace_outlined,
              onTap: () {
                HapticFeedback.selectionClick();
                onBackspace();
              },
              semanticsLabel: context.l10n.backspace,
            ),
          ],
        ),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({
    required this.length,
    required this.maxLength,
    required this.error,
    required this.color,
    required this.muted,
  });

  final int length;
  final int maxLength;
  final bool error;
  final Color color;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final count = maxLength.clamp(4, 6);
    return AnimatedPadding(
      duration: const Duration(milliseconds: 80),
      padding: EdgeInsets.only(left: error ? 6 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (i) {
          final filled = i < length;
          return AnimatedContainer(
            duration: AppShadows.normal,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Unfilled dots sit in a recessed well; filled dots are solid.
              color: filled ? color : colors.surfaceHigh,
              border: Border.all(color: filled ? color : colors.border, width: 1.4),
              boxShadow: filled
                  ? null
                  : [
                      BoxShadow(
                        color: colors.shadowDark.withValues(alpha: 0.5),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                      BoxShadow(
                        color: colors.shadowLight.withValues(alpha: 0.6),
                        offset: const Offset(-2, -2),
                        blurRadius: 4,
                      ),
                    ],
            ),
          );
        }),
      ),
    );
  }
}
