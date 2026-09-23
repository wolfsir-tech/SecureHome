import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/utils/phone_utils.dart';
import 'package:secure_home/domain/entities/auth_method.dart';
import 'package:secure_home/l10n/generated/app_localizations.dart';
import 'package:secure_home/l10n/l10n.dart';
import 'package:secure_home/presentation/providers/providers.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';
import 'package:secure_home/presentation/widgets/pin_keypad.dart';
import 'package:secure_home/presentation/widgets/primary_button.dart';

class ChangePhoneScreen extends ConsumerStatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  ConsumerState<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends ConsumerState<ChangePhoneScreen> {
  bool _unlocked = false;
  String _pin = '';
  String? _error;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    _phone = TextEditingController(text: ref.read(settingsProvider).alarmPhoneE164 ?? '+98');
    _tryBiometric();
  }

  Future<void> _tryBiometric() async {
    final settings = ref.read(settingsProvider);
    if (!settings.biometricEnabled) return;
    final result = await ref.read(authenticationServiceProvider).authenticateBiometric(
          reason: context.l10n.changePhoneAuthReason,
        );
    if (result == UnlockResult.success && mounted) {
      setState(() => _unlocked = true);
    }
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.alarmPhoneLabel)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: _unlocked ? _editor(colors, l10n) : _gate(colors, l10n),
      ),
    );
  }

  Widget _gate(AppColors colors, AppLocalizations l10n) {
    final settings = ref.watch(settingsProvider);
    return Column(
      children: [
        Text(l10n.confirmIdentity, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          l10n.changePhoneGateMessage,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
        ),
        const SizedBox(height: 24),
        if (_error != null) Text(_error!, style: TextStyle(color: colors.disarmed)),
        const Spacer(),
        if (settings.pinEnabled)
          PinKeypad(
            length: _pin.length,
            maxLength: AppConstants.pinMaxLength,
            onDigit: (d) async {
              if (_pin.length >= AppConstants.pinMaxLength) return;
              setState(() => _pin += d);
              if (_pin.length >= AppConstants.pinMinLength) {
                final result = await ref.read(authenticationServiceProvider).verifyPin(_pin);
                if (result == UnlockResult.success) {
                  setState(() => _unlocked = true);
                } else if (_pin.length >= AppConstants.pinMaxLength) {
                  setState(() {
                    _error = l10n.noMatch;
                    _pin = '';
                  });
                }
              }
            },
            onBackspace: () {
              if (_pin.isEmpty) return;
              setState(() => _pin = _pin.substring(0, _pin.length - 1));
            },
            onBiometric: settings.biometricEnabled ? _tryBiometric : null,
          )
        else
          PrimaryButton(label: l10n.useFingerprint, onPressed: _tryBiometric),
        const Spacer(),
      ],
    );
  }

  Widget _editor(AppColors colors, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.changeAlarmPhone, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          l10n.useSimCardNumber,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _phone,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d+\s-]'))],
          decoration: InputDecoration(labelText: l10n.alarmPhoneLabel),
        ),
        const Spacer(),
        PrimaryButton(
          label: l10n.saveNumber,
          onPressed: () async {
            final phone = PhoneUtils.normalize(_phone.text);
            if (phone == null) {
              setState(() => _error = l10n.invalidAlarmPhone);
              return;
            }
            await ref.read(settingsProvider.notifier).setPhone(phone);
            if (mounted) context.pop();
          },
        ),
      ],
    );
  }
}
