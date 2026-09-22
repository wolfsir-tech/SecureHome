import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/errors/error_mapper.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/utils/formatters.dart';
import 'package:secure_home/core/utils/phone_utils.dart';
import 'package:secure_home/domain/entities/auth_method.dart';
import 'package:secure_home/domain/entities/sim_card_info.dart';
import 'package:secure_home/presentation/providers/app_lock_provider.dart';
import 'package:secure_home/presentation/providers/history_provider.dart';
import 'package:secure_home/presentation/providers/providers.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';
import 'package:secure_home/presentation/widgets/section_header.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  List<SimCardInfo> _sims = [];
  String? _testMessage;
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    _loadSims();
  }

  Future<void> _loadSims() async {
    try {
      final sims = await ref.read(simCardServiceProvider).list();
      if (mounted) setState(() => _sims = sims);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const SectionHeader('Security'),
          _tile(
            context,
            icon: Icons.pin_rounded,
            title: 'Change PIN',
            onTap: () => context.push('/settings/security?focus=pin'),
          ),
          _tile(
            context,
            icon: Icons.pattern_rounded,
            title: 'Change pattern',
            onTap: () => context.push('/settings/security?focus=pattern'),
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            secondary: const Icon(Icons.fingerprint_rounded),
            title: const Text('Fingerprint'),
            subtitle: const Text('Unlock with biometrics first'),
            value: settings.biometricEnabled,
            onChanged: (v) async {
              if (v) {
                final ok = await ref.read(authenticationServiceProvider).authenticateBiometric(
                      reason: 'Enable fingerprint unlock',
                    );
                if (ok != UnlockResult.success) return;
              }
              await ref.read(settingsProvider.notifier).setBiometricEnabled(v);
            },
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            secondary: const Icon(Icons.verified_user_outlined),
            title: const Text('Confirm actions with fingerprint'),
            value: settings.confirmWithBiometrics,
            onChanged: settings.biometricEnabled
                ? (v) => ref.read(settingsProvider.notifier).setConfirmWithBiometrics(v)
                : null,
          ),
          _tile(
            context,
            icon: Icons.timer_outlined,
            title: 'Auto-lock',
            subtitle: Formatters.autoLockLabel(settings.autoLockTimeout),
            onTap: () => _pickTimeout(context),
          ),
          const SectionHeader('Alarm'),
          _tile(
            context,
            icon: Icons.phone_rounded,
            title: 'Alarm phone number',
            subtitle: settings.alarmPhoneE164 == null
                ? 'Not set'
                : PhoneUtils.mask(settings.alarmPhoneE164!),
            onTap: () => context.push('/settings/phone'),
          ),
          _tile(
            context,
            icon: Icons.sms_rounded,
            title: 'Test SMS',
            subtitle: _testing ? 'Checking...' : _testMessage,
            onTap: _testing ? null : _testSms,
          ),
          _tile(
            context,
            icon: Icons.sim_card_rounded,
            title: 'SMS SIM',
            subtitle: _simLabel(settings.smsSubscriptionId),
            onTap: () => _pickSim(context),
          ),
          const SectionHeader('Appearance'),
          _tile(
            context,
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: _themeLabel(settings.themeMode),
            onTap: () => _pickTheme(context),
          ),
          const SectionHeader('Application'),
          _tile(
            context,
            icon: Icons.info_outline_rounded,
            title: 'About',
            subtitle: 'Version ${AppConstants.version}',
            onTap: () => context.push('/settings/about'),
          ),
          _tile(
            context,
            icon: Icons.restart_alt_rounded,
            title: 'Reset application',
            color: colors.disarmed,
            onTap: () => _reset(context),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light mode';
      case ThemeMode.dark:
        return 'Dark mode';
      case ThemeMode.system:
        return 'System default';
    }
  }

  String _simLabel(int? id) {
    if (_sims.isEmpty) return 'Default SIM';
    if (id == null) return _sims.length == 1 ? _sims.first.label : 'Ask system default';
    final match = _sims.where((s) => s.subscriptionId == id);
    return match.isEmpty ? 'SIM $id' : match.first.label;
  }

  Future<void> _pickTheme(BuildContext context) async {
    final current = ref.read(settingsProvider).themeMode;
    final next = await showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('Light mode'),
            value: ThemeMode.light,
            groupValue: current,
            onChanged: (v) => Navigator.pop(context, v),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark mode'),
            value: ThemeMode.dark,
            groupValue: current,
            onChanged: (v) => Navigator.pop(context, v),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System default'),
            value: ThemeMode.system,
            groupValue: current,
            onChanged: (v) => Navigator.pop(context, v),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
    if (next != null) await ref.read(settingsProvider.notifier).setThemeMode(next);
  }

  Future<void> _pickTimeout(BuildContext context) async {
    final current = ref.read(settingsProvider).autoLockTimeout;
    final next = await showModalBottomSheet<Duration>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: AppConstants.autoLockOptions
            .map(
              (d) => RadioListTile(
                title: Text(Formatters.autoLockLabel(d)),
                value: d,
                groupValue: current,
                onChanged: (v) => Navigator.pop(context, v),
              ),
            )
            .toList(),
      ),
    );
    if (next != null) await ref.read(settingsProvider.notifier).setAutoLock(next);
  }

  Future<void> _pickSim(BuildContext context) async {
    await _loadSims();
    if (!context.mounted) return;
    if (_sims.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please insert a SIM card.')),
      );
      return;
    }
    final current = ref.read(settingsProvider).smsSubscriptionId;
    final next = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: _sims
            .map(
              (sim) => RadioListTile<int>(
                title: Text(sim.label),
                value: sim.subscriptionId,
                groupValue: current,
                onChanged: (v) => Navigator.pop(context, v),
              ),
            )
            .toList(),
      ),
    );
    if (next != null) await ref.read(settingsProvider.notifier).setSmsSubscription(next);
  }

  Future<void> _testSms() async {
    setState(() {
      _testing = true;
      _testMessage = null;
    });
    final permissions = ref.read(permissionServiceProvider);
    final sms = ref.read(smsServiceProvider);
    final settings = ref.read(settingsProvider);
    try {
      await permissions.ensureSms();
      final capable = await sms.isSmsCapable();
      if (!capable) {
        setState(() => _testMessage = 'Check your SIM card');
        return;
      }
      final sims = await ref.read(simCardServiceProvider).list();
      if (sims.isEmpty) {
        setState(() => _testMessage = 'Please insert a SIM card.');
        return;
      }
      if (settings.alarmPhoneE164 == null || !PhoneUtils.isValid(settings.alarmPhoneE164!)) {
        setState(() => _testMessage = 'The alarm phone number is invalid.');
        return;
      }
      setState(() => _testMessage = 'Ready to send commands.');
    } catch (e) {
      setState(() => _testMessage = ErrorMapper.userMessage(e));
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _reset(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset application?'),
        content: const Text('This erases the alarm number, lock, and history on this device.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reset')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(settingsProvider.notifier).resetApplication();
    await ref.read(historyProvider.notifier).clear();
    ref.read(appLockProvider.notifier).unlock();
    if (context.mounted) context.go('/onboarding');
  }
}
