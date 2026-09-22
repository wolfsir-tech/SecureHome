import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/theme/app_colors.dart';

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
          muted: colors.border,
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
                    (d) => _Key(
                      label: d,
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
            _Key(
              icon: onBiometric == null ? null : Icons.fingerprint_rounded,
              onTap: onBiometric,
            ),
            _Key(
              label: '0',
              onTap: () {
                HapticFeedback.selectionClick();
                onDigit('0');
              },
            ),
            _Key(
              icon: Icons.backspace_outlined,
              onTap: () {
                HapticFeedback.selectionClick();
                onBackspace();
              },
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
    final count = maxLength.clamp(AppConstants.pinMinLength, AppConstants.pinMaxLength);
    return AnimatedPadding(
      duration: const Duration(milliseconds: 80),
      padding: EdgeInsets.only(left: error ? 6 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (i) {
          final filled = i < length;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? color : Colors.transparent,
              border: Border.all(color: filled ? color : muted, width: 1.6),
            ),
          );
        }),
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({this.label, this.icon, this.onTap});

  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: label ?? (icon == Icons.fingerprint_rounded ? 'Fingerprint' : 'Backspace'),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 76,
          height: 76,
          child: Center(
            child: icon != null
                ? Icon(icon, color: colors.textMuted, size: 26)
                : Text(
                    label ?? '',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: colors.text,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
