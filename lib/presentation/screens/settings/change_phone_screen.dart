import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/utils/phone_utils.dart';
import 'package:secure_home/domain/entities/auth_method.dart';
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
          reason: 'Confirm to change the alarm number',
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
    return Scaffold(
      appBar: AppBar(title: const Text('Alarm phone number')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: _unlocked ? _editor(colors) : _gate(colors),
      ),
    );
  }

  Widget _gate(AppColors colors) {
    final settings = ref.watch(settingsProvider);
    return Column(
      children: [
        Text('Confirm it is you', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Changing the alarm number requires authentication.',
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
                    _error = 'That did not match. Try again.';
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
          PrimaryButton(label: 'Use fingerprint', onPressed: _tryBiometric),
        const Spacer(),
      ],
    );
  }

  Widget _editor(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Change alarm phone number', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Use the SIM card number inside the alarm.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _phone,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d+\s-]'))],
          decoration: const InputDecoration(labelText: 'Alarm phone number'),
        ),
        const Spacer(),
        PrimaryButton(
          label: 'Save number',
          onPressed: () async {
            final phone = PhoneUtils.normalize(_phone.text);
            if (phone == null) {
              setState(() => _error = 'The alarm phone number is invalid.');
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
