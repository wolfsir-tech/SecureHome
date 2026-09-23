import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/utils/formatters.dart';
import 'package:secure_home/core/utils/phone_utils.dart';
import 'package:secure_home/domain/entities/alarm_state.dart';
import 'package:secure_home/domain/entities/auth_method.dart';
import 'package:secure_home/domain/entities/command_history_item.dart';
import 'package:secure_home/l10n/generated/app_localizations.dart';
import 'package:secure_home/l10n/l10n.dart';
import 'package:secure_home/presentation/providers/alarm_provider.dart';
import 'package:secure_home/presentation/providers/app_lock_provider.dart';
import 'package:secure_home/presentation/providers/history_provider.dart';
import 'package:secure_home/presentation/providers/providers.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';
import 'package:secure_home/presentation/widgets/confirm_sheet.dart';
import 'package:secure_home/presentation/widgets/primary_button.dart';
import 'package:secure_home/presentation/widgets/sms_flow_dialog.dart';
import 'package:secure_home/presentation/widgets/status_ring.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final alarm = ref.watch(alarmProvider);
    final settings = ref.watch(settingsProvider);
    final history = ref.watch(historyProvider).take(3).toList();
    final copy = _copyFor(alarm.status, l10n);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final ringSize = (constraints.maxWidth * 0.52).clamp(168.0, 230.0);
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('SecureHome', style: Theme.of(context).textTheme.titleLarge),
                      const Spacer(),
                      IconButton(
                        tooltip: l10n.lockTitle,
                        onPressed: () => ref.read(appLockProvider.notifier).lock(),
                        icon: const Icon(Icons.lock_outline_rounded),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          StatusRing(status: alarm.status, size: ringSize),
                          const SizedBox(height: 18),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 280),
                            child: Text(
                              copy.title,
                              key: ValueKey(copy.title),
                              style: Theme.of(context).textTheme.headlineLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            copy.subtitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.alarmPhoneLabel,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            settings.alarmPhoneE164 == null
                                ? l10n.notSet
                                : PhoneUtils.mask(settings.alarmPhoneE164!),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (settings.lastCommandAt != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              l10n.lastCommandAt(Formatters.dateTime(settings.lastCommandAt!)),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                          const SizedBox(height: 28),
                          PrimaryButton(
                            label: l10n.armAlarm,
                            icon: Icons.security_rounded,
                            color: colors.disarmed,
                            foreground: Colors.white,
                            enabled: !alarm.status.isBusy,
                            onPressed: () => _arm(context, ref),
                          ),
                          const SizedBox(height: 12),
                          GhostButton(
                            label: l10n.disarmAlarm,
                            icon: Icons.lock_open_rounded,
                            color: colors.secured,
                            onPressed: alarm.status.isBusy ? null : () => _disarm(context, ref),
                          ),
                          const SizedBox(height: 28),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(l10n.recentActivity, style: Theme.of(context).textTheme.titleMedium),
                          ),
                          const SizedBox(height: 10),
                          if (history.isEmpty)
                            Text(
                              l10n.noCommandsYet,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
                            )
                          else
                            ...history.map((item) => _ActivityTile(item: item)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _arm(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await showConfirmSheet(
      context: context,
      title: l10n.armConfirmTitle,
      message: l10n.armConfirmMessage,
      confirmLabel: l10n.activate,
      confirmColor: context.colors.disarmed,
      confirmForeground: Colors.white,
    );
    if (!ok || !context.mounted) return;
    if (!await _maybeBiometric(context, ref)) return;
    if (!context.mounted) return;
    final future = ref.read(alarmProvider.notifier).arm();
    await showSmsFlowDialog(context, ref);
    await future;
  }

  Future<void> _disarm(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await showConfirmSheet(
      context: context,
      title: l10n.disarmConfirmTitle,
      message: l10n.disarmConfirmMessage,
      confirmLabel: l10n.disableAlarm,
      confirmColor: context.colors.secured,
      confirmForeground: Colors.white,
    );
    if (!ok || !context.mounted) return;
    if (!await _maybeBiometric(context, ref)) return;
    if (!context.mounted) return;
    final future = ref.read(alarmProvider.notifier).disarm();
    await showSmsFlowDialog(context, ref);
    await future;
  }

  Future<bool> _maybeBiometric(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsProvider);
    if (!settings.confirmWithBiometrics || !settings.biometricEnabled) return true;
    final result = await ref.read(authenticationServiceProvider).authenticateBiometric(
          reason: context.l10n.biometricReasonArm,
        );
    if (result == UnlockResult.success) return true;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.commandCancelled)),
      );
    }
    return false;
  }

  _StatusCopy _copyFor(AlarmStatus status, AppLocalizations l10n) {
    switch (status) {
      case AlarmStatus.secured:
        return _StatusCopy(l10n.statusSecuredTitle, l10n.statusSecuredSubtitle);
      case AlarmStatus.disarmed:
        return _StatusCopy(l10n.statusDisarmedTitle, l10n.statusDisarmedSubtitle);
      case AlarmStatus.activating:
        return _StatusCopy(l10n.statusActivatingTitle, l10n.statusSendingSubtitle);
      case AlarmStatus.deactivating:
        return _StatusCopy(l10n.statusDeactivatingTitle, l10n.statusSendingSubtitle);
      case AlarmStatus.sending:
        return _StatusCopy(l10n.statusSendingTitle, l10n.statusSendingSubtitle);
      case AlarmStatus.error:
        return _StatusCopy(l10n.statusErrorTitle, l10n.statusErrorSubtitle);
      case AlarmStatus.unknown:
        return _StatusCopy(l10n.statusUnknownTitle, l10n.statusUnknownSubtitle);
    }
  }
}

class _StatusCopy {
  const _StatusCopy(this.title, this.subtitle);
  final String title;
  final String subtitle;
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item});

  final CommandHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ok = item.status == HistoryStatus.sent;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 18,
            color: ok ? colors.secured : colors.disarmed,
          ),
          const SizedBox(width: 10),
          Text(Formatters.time(item.timestamp), style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.action == HistoryAction.arm
                  ? context.l10n.alarmArmed
                  : context.l10n.alarmDisarmed,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
