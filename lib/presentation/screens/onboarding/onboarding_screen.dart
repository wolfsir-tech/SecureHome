import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/utils/phone_utils.dart';
import 'package:secure_home/domain/entities/auth_method.dart';
import 'package:secure_home/presentation/providers/app_lock_provider.dart';
import 'package:secure_home/presentation/providers/providers.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';
import 'package:secure_home/presentation/widgets/brand_mark.dart';
import 'package:secure_home/presentation/widgets/pattern_lock.dart';
import 'package:secure_home/presentation/widgets/pin_keypad.dart';
import 'package:secure_home/presentation/widgets/primary_button.dart';
import 'package:secure_home/presentation/widgets/shake.dart';

enum _Step { welcome, phone, methods, pin, pinConfirm, pattern, patternConfirm, biometric, permission, ready }

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  _Step _step = _Step.welcome;
  final _phone = TextEditingController(text: '+98');
  final _patternKey = GlobalKey<PatternLockState>();

  bool _wantPin = true;
  bool _wantPattern = false;
  bool _wantBiometric = false;
  bool _biometricsAvailable = false;

  String _pin = '';
  String _pinDraft = '';
  List<int> _pattern = [];
  String? _error;
  bool _shake = false;
  bool _busy = false;
  PermissionStatus? _smsStatus;

  @override
  void initState() {
    super.initState();
    _loadBiometrics();
  }

  Future<void> _loadBiometrics() async {
    final available = await ref.read(authenticationServiceProvider).canUseBiometrics();
    if (mounted) setState(() => _biometricsAvailable = available);
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _fail(String message) {
    setState(() {
      _error = message;
      _shake = true;
    });
    HapticFeedback.heavyImpact();
    Future<void>.delayed(const Duration(milliseconds: 420), () {
      if (mounted) setState(() => _shake = false);
    });
  }

  Future<void> _next() async {
    setState(() => _error = null);
    switch (_step) {
      case _Step.welcome:
        setState(() => _step = _Step.phone);
      case _Step.phone:
        final phone = PhoneUtils.normalize(_phone.text);
        if (phone == null) {
          _fail('The alarm phone number is invalid.');
          return;
        }
        setState(() => _step = _Step.methods);
      case _Step.methods:
        if (!_wantPin && !_wantPattern) {
          _fail('Choose a PIN or a pattern as a backup lock.');
          return;
        }
        setState(() => _step = _wantPin ? _Step.pin : _Step.pattern);
      case _Step.pin:
        if (_pinDraft.length < AppConstants.pinMinLength) {
          _fail('Choose a 4 to 6 digit PIN.');
          return;
        }
        setState(() {
          _pin = _pinDraft;
          _pinDraft = '';
          _step = _Step.pinConfirm;
        });
      case _Step.pinConfirm:
        if (_pinDraft != _pin) {
          _pinDraft = '';
          _fail('Those PINs did not match.');
          return;
        }
        await ref.read(authenticationServiceProvider).setPin(_pin);
        setState(() {
          _pinDraft = '';
          _step = _wantPattern ? _Step.pattern : (_wantBiometric ? _Step.biometric : _Step.permission);
        });
      case _Step.pattern:
        setState(() => _step = _Step.patternConfirm);
      case _Step.patternConfirm:
        setState(
          () => _step = _wantBiometric ? _Step.biometric : _Step.permission,
        );
      case _Step.biometric:
        setState(() => _step = _Step.permission);
      case _Step.permission:
        setState(() => _step = _Step.ready);
      case _Step.ready:
        await _finish();
    }
  }

  Future<void> _finish() async {
    setState(() => _busy = true);
    final phone = PhoneUtils.normalize(_phone.text)!;
    await ref.read(settingsProvider.notifier).completeOnboarding(
          phone: phone,
          pinEnabled: _wantPin,
          patternEnabled: _wantPattern,
          biometricEnabled: _wantBiometric,
        );
    ref.read(appLockProvider.notifier).unlock();
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopBar(
                progress: (_step.index + 1) / _Step.values.length,
                onBack: _step == _Step.welcome
                    ? null
                    : () => setState(() {
                          _error = null;
                          _pinDraft = '';
                          _step = _Step.values[_step.index - 1];
                        }),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Shake(
                  play: _shake,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: KeyedSubtree(
                      key: ValueKey(_step),
                      child: _body(colors),
                    ),
                  ),
                ),
              ),
              if (_error != null) ...[
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.disarmed, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
              ],
              if (_showsPrimary) PrimaryButton(label: _cta, onPressed: _busy ? null : _next, loading: _busy),
            ],
          ),
        ),
      ),
    );
  }

  bool get _showsPrimary =>
      _step != _Step.pin &&
      _step != _Step.pinConfirm &&
      _step != _Step.pattern &&
      _step != _Step.patternConfirm;

  String get _cta {
    switch (_step) {
      case _Step.welcome:
        return 'Get started';
      case _Step.ready:
        return 'Enter SecureHome';
      case _Step.permission:
        return 'Continue';
      default:
        return 'Continue';
    }
  }

  Widget _body(AppColors colors) {
    switch (_step) {
      case _Step.welcome:
        return _Welcome(colors: colors);
      case _Step.phone:
        return _PhoneStep(controller: _phone);
      case _Step.methods:
        return _MethodsStep(
          pin: _wantPin,
          pattern: _wantPattern,
          biometric: _wantBiometric,
          biometricAvailable: _biometricsAvailable,
          onPin: (v) => setState(() => _wantPin = v),
          onPattern: (v) => setState(() => _wantPattern = v),
          onBiometric: (v) => setState(() => _wantBiometric = v),
        );
      case _Step.pin:
      case _Step.pinConfirm:
        return _PinStep(
          title: _step == _Step.pin ? 'Create a PIN' : 'Confirm your PIN',
          subtitle: '4 to 6 digits. This keeps SecureHome locked.',
          length: _pinDraft.length,
          onDigit: (d) {
            if (_pinDraft.length >= AppConstants.pinMaxLength) return;
            setState(() => _pinDraft += d);
            if (_pinDraft.length >= AppConstants.pinMinLength &&
                _pinDraft.length >= (_step == _Step.pinConfirm ? _pin.length : AppConstants.pinMinLength) &&
                (_step == _Step.pinConfirm || _pinDraft.length == AppConstants.pinMaxLength)) {
              _next();
            }
          },
          onBackspace: () {
            if (_pinDraft.isEmpty) return;
            setState(() => _pinDraft = _pinDraft.substring(0, _pinDraft.length - 1));
          },
          onContinue: _pinDraft.length >= AppConstants.pinMinLength ? _next : null,
        );
      case _Step.pattern:
      case _Step.patternConfirm:
        return _PatternStep(
          key: ValueKey(_step),
          title: _step == _Step.pattern ? 'Draw a pattern' : 'Confirm your pattern',
          error: _error != null,
          patternKey: _patternKey,
          onComplete: (pattern) async {
            if (pattern.length < AppConstants.patternMinLength) {
              _patternKey.currentState?.reset();
              _fail('Connect at least 4 dots.');
              return;
            }
            if (_step == _Step.pattern) {
              _pattern = pattern;
              setState(() => _step = _Step.patternConfirm);
              return;
            }
            if (pattern.join() != _pattern.join()) {
              _patternKey.currentState?.reset();
              _fail('Those patterns did not match.');
              return;
            }
            await ref.read(authenticationServiceProvider).setPattern(pattern);
            setState(
              () => _step = _wantBiometric ? _Step.biometric : _Step.permission,
            );
          },
        );
      case _Step.biometric:
        return _BiometricStep(
          available: _biometricsAvailable,
          onEnable: () async {
            final result = await ref.read(authenticationServiceProvider).authenticateBiometric(
                  reason: 'Enable fingerprint unlock',
                );
            if (result == UnlockResult.success) {
              setState(() {
                _wantBiometric = true;
                _step = _Step.permission;
              });
            } else {
              _fail('Fingerprint was not verified.');
            }
          },
          onSkip: () => setState(() {
            _wantBiometric = false;
            _step = _Step.permission;
          }),
        );
      case _Step.permission:
        return _PermissionStep(
          status: _smsStatus,
          onRequest: () async {
            final granted = await ref.read(permissionServiceProvider).requestAlarmPermissions();
            final status = await Permission.sms.status;
            setState(() => _smsStatus = status);
            if (granted) {
              setState(() => _step = _Step.ready);
            }
          },
          onSkip: () => setState(() => _step = _Step.ready),
          onSettings: () => ref.read(permissionServiceProvider).openSettings(),
        );
      case _Step.ready:
        final phone = PhoneUtils.normalize(_phone.text) ?? _phone.text;
        return _ReadyStep(masked: PhoneUtils.mask(phone));
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.progress, this.onBack});

  final double progress;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        if (onBack != null)
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
          )
        else
          const SizedBox(width: 48),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: colors.surfaceHigh,
              color: colors.accent,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandMark(size: 72),
        const SizedBox(height: 28),
        Text('Protect your home. Simply.', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 14),
        Text(
          'SecureHome sends SMS commands to your GSM alarm. No cloud. No account. Just this device and your alarm SIM.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted, height: 1.45),
        ),
      ],
    );
  }
}

class _PhoneStep extends StatelessWidget {
  const _PhoneStep({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alarm phone number', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 10),
        Text(
          'Enter the SIM card number inside your alarm system.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          autofillHints: const [AutofillHints.telephoneNumber],
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d+\s-]')),
          ],
          style: Theme.of(context).textTheme.headlineMedium,
          decoration: const InputDecoration(
            hintText: '+98 912 123 4567',
            labelText: 'Alarm phone number',
          ),
        ),
      ],
    );
  }
}

class _MethodsStep extends StatelessWidget {
  const _MethodsStep({
    required this.pin,
    required this.pattern,
    required this.biometric,
    required this.biometricAvailable,
    required this.onPin,
    required this.onPattern,
    required this.onBiometric,
  });

  final bool pin;
  final bool pattern;
  final bool biometric;
  final bool biometricAvailable;
  final ValueChanged<bool> onPin;
  final ValueChanged<bool> onPattern;
  final ValueChanged<bool> onBiometric;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text('Lock SecureHome', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 10),
        Text(
          'Choose how you unlock the app. A PIN or pattern is required.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: context.colors.textMuted),
        ),
        const SizedBox(height: 20),
        _MethodTile(
          icon: Icons.pin_rounded,
          title: 'Numeric PIN',
          subtitle: 'A 4 to 6 digit code',
          value: pin,
          onChanged: onPin,
        ),
        _MethodTile(
          icon: Icons.pattern_rounded,
          title: 'Pattern lock',
          subtitle: 'Connect at least 4 dots',
          value: pattern,
          onChanged: onPattern,
        ),
        _MethodTile(
          icon: Icons.fingerprint_rounded,
          title: 'Fingerprint',
          subtitle: biometricAvailable ? 'Unlock with biometrics first' : 'Not available on this device',
          value: biometric && biometricAvailable,
          onChanged: biometricAvailable ? onBiometric : null,
        ),
      ],
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colors.border),
        ),
        tileColor: colors.surface,
        secondary: Icon(icon, color: colors.accent),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}

class _PinStep extends StatelessWidget {
  const _PinStep({
    required this.title,
    required this.subtitle,
    required this.length,
    required this.onDigit,
    required this.onBackspace,
    this.onContinue,
  });

  final String title;
  final String subtitle;
  final int length;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(subtitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        PinKeypad(
          length: length,
          maxLength: AppConstants.pinMaxLength,
          onDigit: onDigit,
          onBackspace: onBackspace,
        ),
        const Spacer(),
        PrimaryButton(label: 'Continue', onPressed: onContinue),
      ],
    );
  }
}

class _PatternStep extends StatelessWidget {
  const _PatternStep({
    super.key,
    required this.title,
    required this.onComplete,
    required this.error,
    required this.patternKey,
  });

  final String title;
  final ValueChanged<List<int>> onComplete;
  final bool error;
  final GlobalKey<PatternLockState> patternKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Connect at least 4 dots.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.colors.textMuted),
        ),
        const Spacer(),
        PatternLock(key: patternKey, onComplete: onComplete, error: error),
        const Spacer(),
      ],
    );
  }
}

class _BiometricStep extends StatelessWidget {
  const _BiometricStep({
    required this.available,
    required this.onEnable,
    required this.onSkip,
  });

  final bool available;
  final VoidCallback onEnable;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        const Spacer(),
        Icon(Icons.fingerprint_rounded, size: 88, color: colors.accent),
        const SizedBox(height: 20),
        Text('Use fingerprint', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        Text(
          available
              ? 'Unlock SecureHome faster with the fingerprint already on this device.'
              : 'Fingerprint is not available on this device.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted),
        ),
        const Spacer(),
        PrimaryButton(label: 'Enable fingerprint', onPressed: available ? onEnable : null),
        const SizedBox(height: 10),
        GhostButton(label: 'Not now', onPressed: onSkip),
      ],
    );
  }
}

class _PermissionStep extends StatelessWidget {
  const _PermissionStep({
    required this.status,
    required this.onRequest,
    required this.onSkip,
    required this.onSettings,
  });

  final PermissionStatus? status;
  final VoidCallback onRequest;
  final VoidCallback onSkip;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final deniedForever = status?.isPermanentlyDenied ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Allow SMS', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(
          'SecureHome needs SMS permission to send commands to your alarm.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted, height: 1.45),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Icon(Icons.sms_rounded, color: colors.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Commands stay on this phone. Nothing is sent to a server.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        PrimaryButton(
          label: deniedForever ? 'Open Android Settings' : 'Allow SMS',
          onPressed: deniedForever ? onSettings : onRequest,
        ),
        const SizedBox(height: 10),
        GhostButton(label: 'Skip for now', onPressed: onSkip),
      ],
    );
  }
}

class _ReadyStep extends StatelessWidget {
  const _ReadyStep({required this.masked});

  final String masked;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        const Spacer(),
        Icon(Icons.check_circle_rounded, size: 72, color: colors.secured),
        const SizedBox(height: 18),
        Text('Your alarm is ready.', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(
          'Commands will be sent to',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted),
        ),
        const SizedBox(height: 6),
        Text(masked, style: Theme.of(context).textTheme.headlineMedium),
        const Spacer(),
      ],
    );
  }
}
