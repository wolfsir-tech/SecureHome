import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/errors/error_mapper.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/utils/formatters.dart';
import 'package:secure_home/core/utils/phone_utils.dart';
import 'package:secure_home/domain/entities/app_settings.dart';
import 'package:secure_home/domain/entities/auth_method.dart';
import 'package:secure_home/domain/entities/sim_card_info.dart';
import 'package:secure_home/l10n/generated/app_localizations.dart';
import 'package:secure_home/l10n/l10n.dart';
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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          SectionHeader(l10n.securitySection),
          _tile(
            context,
            icon: Icons.pin_rounded,
            title: l10n.changePin,
            onTap: () => context.push('/settings/security?focus=pin'),
          ),
          _tile(
            context,
            icon: Icons.pattern_rounded,
            title: l10n.changePattern,
            onTap: () => context.push('/settings/security?focus=pattern'),
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            secondary: const Icon(Icons.fingerprint_rounded),
            title: Text(l10n.fingerprint),
            subtitle: Text(l10n.unlockBiometricFirst),
            value: settings.biometricEnabled,
            onChanged: (v) async {
              if (v) {
                final ok = await ref.read(authenticationServiceProvider).authenticateBiometric(
                      reason: l10n.biometricReasonEnable,
                    );
                if (ok != UnlockResult.success) return;
              }
              await ref.read(settingsProvider.notifier).setBiometricEnabled(v);
            },
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            secondary: const Icon(Icons.verified_user_outlined),
            title: Text(l10n.confirmActionsBiometric),
            value: settings.confirmWithBiometrics,
            onChanged: settings.biometricEnabled
                ? (v) => ref.read(settingsProvider.notifier).setConfirmWithBiometrics(v)
                : null,
          ),
          _tile(
            context,
            icon: Icons.timer_outlined,
            title: l10n.autoLock,
            subtitle: Formatters.autoLockLabel(settings.autoLockTimeout, l10n),
            onTap: () => _pickTimeout(context),
          ),
          SectionHeader(l10n.alarmSection),
          _tile(
            context,
            icon: Icons.phone_rounded,
            title: l10n.alarmPhoneLabel,
            subtitle: settings.alarmPhoneE164 == null
                ? l10n.notSet
                : PhoneUtils.mask(settings.alarmPhoneE164!),
            onTap: () => context.push('/settings/phone'),
          ),
          _tile(
            context,
            icon: Icons.sms_rounded,
            title: l10n.testSms,
            subtitle: _testing ? l10n.checking : _testMessage,
            onTap: _testing ? null : _testSms,
          ),
          _tile(
            context,
            icon: Icons.sim_card_rounded,
            title: l10n.smsSim,
            subtitle: _simLabel(settings.smsSubscriptionId, l10n),
            onTap: () => _pickSim(context),
          ),
          SectionHeader(l10n.appearanceSection),
          _tile(
            context,
            icon: Icons.palette_outlined,
            title: l10n.theme,
            subtitle: _themeLabel(settings.themeMode, l10n),
            onTap: () => _pickTheme(context),
          ),
          _tile(
            context,
            icon: Icons.language_rounded,
            title: l10n.language,
            subtitle: _localeLabel(settings.locale, l10n),
            onTap: () => _pickLocale(context),
          ),
          SectionHeader(l10n.applicationSection),
          _tile(
            context,
            icon: Icons.info_outline_rounded,
            title: l10n.about,
            subtitle: l10n.version(AppConstants.version),
            onTap: () => context.push('/settings/about'),
          ),
          _tile(
            context,
            icon: Icons.restart_alt_rounded,
            title: l10n.resetApplication,
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

  String _themeLabel(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.lightMode;
      case ThemeMode.dark:
        return l10n.darkMode;
      case ThemeMode.system:
        return l10n.systemDefault;
    }
  }

  String _localeLabel(AppLocale locale, AppLocalizations l10n) {
    switch (locale) {
      case AppLocale.en:
        return l10n.languageEnglish;
      case AppLocale.fa:
        return l10n.languagePersian;
      case AppLocale.system:
        return l10n.systemDefault;
    }
  }

  String _simLabel(int? id, AppLocalizations l10n) {
    if (_sims.isEmpty) return l10n.defaultSim;
    if (id == null) return _sims.length == 1 ? _sims.first.label : l10n.askSystemDefault;
    final match = _sims.where((s) => s.subscriptionId == id);
    return match.isEmpty ? l10n.simCard(id) : match.first.label;
  }

  Future<void> _pickTheme(BuildContext context) async {
    final l10n = context.l10n;
    final current = ref.read(settingsProvider).themeMode;
    final next = await showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (context) => RadioGroup<ThemeMode>(
        groupValue: current,
        onChanged: (v) => Navigator.pop(context, v),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.lightMode),
              value: ThemeMode.light,
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.darkMode),
              value: ThemeMode.dark,
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.systemDefault),
              value: ThemeMode.system,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (next != null) await ref.read(settingsProvider.notifier).setThemeMode(next);
  }

  Future<void> _pickLocale(BuildContext context) async {
    final l10n = context.l10n;
    final current = ref.read(settingsProvider).locale;
    final next = await showModalBottomSheet<AppLocale>(
      context: context,
      builder: (context) => RadioGroup<AppLocale>(
        groupValue: current,
        onChanged: (v) => Navigator.pop(context, v),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<AppLocale>(
              title: Text(l10n.languageEnglish),
              value: AppLocale.en,
            ),
            RadioListTile<AppLocale>(
              title: Text(l10n.languagePersian),
              value: AppLocale.fa,
            ),
            RadioListTile<AppLocale>(
              title: Text(l10n.systemDefault),
              value: AppLocale.system,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (next != null) await ref.read(settingsProvider.notifier).setLocale(next);
  }

  Future<void> _pickTimeout(BuildContext context) async {
    final l10n = context.l10n;
    final current = ref.read(settingsProvider).autoLockTimeout;
    final next = await showModalBottomSheet<Duration>(
      context: context,
      builder: (context) => RadioGroup<Duration>(
        groupValue: current,
        onChanged: (v) => Navigator.pop(context, v),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.autoLockOptions
              .map(
                (d) => RadioListTile<Duration>(
                  title: Text(Formatters.autoLockLabel(d, l10n)),
                  value: d,
                ),
              )
              .toList(),
        ),
      ),
    );
    if (next != null) await ref.read(settingsProvider.notifier).setAutoLock(next);
  }

  Future<void> _pickSim(BuildContext context) async {
    final l10n = context.l10n;
    await _loadSims();
    if (!context.mounted) return;
    if (_sims.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.insertSim)),
      );
      return;
    }
    final current = ref.read(settingsProvider).smsSubscriptionId;
    final next = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => RadioGroup<int>(
        groupValue: current,
        onChanged: (v) => Navigator.pop(context, v),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _sims
              .map(
                (sim) => RadioListTile<int>(
                  title: Text(sim.label),
                  value: sim.subscriptionId,
                ),
              )
              .toList(),
        ),
      ),
    );
    if (next != null) await ref.read(settingsProvider.notifier).setSmsSubscription(next);
  }

  Future<void> _testSms() async {
    final l10n = context.l10n;
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
        setState(() => _testMessage = l10n.checkSimCard);
        return;
      }
      final sims = await ref.read(simCardServiceProvider).list();
      if (sims.isEmpty) {
        setState(() => _testMessage = l10n.insertSim);
        return;
      }
      if (settings.alarmPhoneE164 == null || !PhoneUtils.isValid(settings.alarmPhoneE164!)) {
        setState(() => _testMessage = l10n.invalidAlarmPhone);
        return;
      }
      setState(() => _testMessage = l10n.readyToSend);
    } catch (e) {
      setState(() => _testMessage = ErrorMapper.userMessage(e));
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _reset(BuildContext context) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetConfirmTitle),
        content: Text(l10n.resetConfirmMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.reset)),
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
