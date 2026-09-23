import 'package:flutter/material.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/l10n/l10n.dart';
import 'package:secure_home/presentation/widgets/primary_button.dart';

Future<bool> showConfirmSheet({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  Color? confirmColor,
  Color? confirmForeground,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final colors = context.colors;
      return Padding(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + MediaQuery.paddingOf(context).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              label: confirmLabel,
              color: confirmColor,
              foreground: confirmForeground,
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: 10),
            GhostButton(
              label: context.l10n.cancel,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      );
    },
  );
  return result ?? false;
}
