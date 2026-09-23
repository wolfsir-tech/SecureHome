import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/utils/phone_utils.dart';
import 'package:secure_home/domain/entities/alarm_state.dart';
import 'package:secure_home/l10n/l10n.dart';
import 'package:secure_home/presentation/providers/alarm_provider.dart';
import 'package:secure_home/presentation/widgets/primary_button.dart';

Future<void> showSmsFlowDialog(BuildContext context, WidgetRef ref) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    pageBuilder: (context, _, __) => const SmsFlowDialog(),
  );
}

class SmsFlowDialog extends ConsumerWidget {
  const SmsFlowDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarm = ref.watch(alarmProvider);
    final colors = context.colors;
    final busy = alarm.status.isBusy;
    final error = alarm.status == AlarmStatus.error;
    final success = alarm.status == AlarmStatus.secured ||
        (alarm.status == AlarmStatus.disarmed && (alarm.message?.contains('sent') ?? false));

    // Close when a terminal result is reached after a send.
    ref.listen(alarmProvider, (prev, next) {
      if (prev?.status.isBusy == true && next.status.isTerminal) {
        Future<void>.delayed(Duration(milliseconds: error ? 0 : 900), () {
          if (context.mounted && next.status != AlarmStatus.error) {
            Navigator.of(context).maybePop();
          }
        });
      }
    });

    final title = busy
        ? context.l10n.sendingCommand
        : error
            ? context.l10n.couldNotSendCommand
            : (alarm.message ?? context.l10n.commandSent);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: busy
                    ? SizedBox(
                        key: const ValueKey('busy'),
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: colors.processing,
                        ),
                      )
                    : Icon(
                        error ? Icons.error_outline_rounded : Icons.check_circle_rounded,
                        key: ValueKey(error),
                        size: 52,
                        color: error ? colors.disarmed : colors.secured,
                      ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (alarm.destination != null) ...[
                const SizedBox(height: 8),
                Text(
                  PhoneUtils.mask(alarm.destination!),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
                ),
              ],
              if (error) ...[
                const SizedBox(height: 8),
                Text(
                  alarm.message ?? context.l10n.pleaseTryAgain,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: context.l10n.close,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ] else if (success && !busy)
                const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
