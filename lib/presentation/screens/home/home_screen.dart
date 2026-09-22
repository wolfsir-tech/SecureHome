import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/utils/formatters.dart';
import 'package:secure_home/core/utils/phone_utils.dart';
import 'package:secure_home/domain/entities/alarm_state.dart';
import 'package:secure_home/domain/entities/auth_method.dart';
import 'package:secure_home/domain/entities/command_history_item.dart';
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
    final alarm = ref.watch(alarmProvider);
    final settings = ref.watch(settingsProvider);
    final history = ref.watch(historyProvider).take(3).toList();
    final copy = _copyFor(alarm.status);

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
                        tooltip: 'Lock',
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
                            'Alarm phone number',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            settings.alarmPhoneE164 == null
                                ? 'Not set'
                                : PhoneUtils.mask(settings.alarmPhoneE164!),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (settings.lastCommandAt != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Last command ${Formatters.dateTime(settings.lastCommandAt!)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                          const SizedBox(height: 28),
                          PrimaryButton(
                            label: 'ARM ALARM',
                            icon: Icons.security_rounded,
                            color: colors.disarmed,
                            foreground: Colors.white,
                            enabled: !alarm.status.isBusy,
                            onPressed: () => _arm(context, ref),
                          ),
                          const SizedBox(height: 12),
                          GhostButton(
                            label: 'DISARM',
                            icon: Icons.lock_open_rounded,
                            color: colors.secured,
                            onPressed: alarm.status.isBusy ? null : () => _disarm(context, ref),
                          ),
                          const SizedBox(height: 28),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Recent activity', style: Theme.of(context).textTheme.titleMedium),
                          ),
                          const SizedBox(height: 10),
                          if (history.isEmpty)
                            Text(
                              'No commands yet.',
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
    final ok = await showConfirmSheet(
      context: context,
      title: 'Activate home alarm?',
      message: 'An SMS command will be sent to the alarm system.',
      confirmLabel: 'Activate',
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
    final ok = await showConfirmSheet(
      context: context,
      title: 'Disable home alarm?',
      message: 'Are you sure you want to send the deactivation command?',
      confirmLabel: 'Disable Alarm',
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
          reason: 'Confirm this alarm command',
        );
    if (result == UnlockResult.success) return true;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Command cancelled.')),
      );
    }
    return false;
  }

  _StatusCopy _copyFor(AlarmStatus status) {
    switch (status) {
      case AlarmStatus.secured:
        return const _StatusCopy('HOME SECURED', 'Home is secured');
      case AlarmStatus.disarmed:
        return const _StatusCopy('ALARM DISARMED', 'Alarm is disarmed');
      case AlarmStatus.activating:
        return const _StatusCopy('ACTIVATING', 'Sending command...');
      case AlarmStatus.deactivating:
        return const _StatusCopy('DEACTIVATING', 'Sending command...');
      case AlarmStatus.sending:
        return const _StatusCopy('SENDING SMS', 'Sending command...');
      case AlarmStatus.error:
        return const _StatusCopy('ERROR', 'Unable to send command');
      case AlarmStatus.unknown:
        return const _StatusCopy('STATUS UNKNOWN', 'Send a command to update status');
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
              item.action == HistoryAction.arm ? 'Alarm armed' : 'Alarm disarmed',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
