import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/domain/entities/auth_method.dart';
import 'package:secure_home/l10n/l10n.dart';
import 'package:secure_home/presentation/providers/app_lock_provider.dart';
import 'package:secure_home/presentation/providers/providers.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';
import 'package:secure_home/presentation/widgets/brand_mark.dart';
import 'package:secure_home/presentation/widgets/pattern_lock.dart';
import 'package:secure_home/presentation/widgets/pin_keypad.dart';
import 'package:secure_home/presentation/widgets/shake.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  late AuthMethod _method;
  String _pin = '';
  bool _error = false;
  bool _shake = false;
  String? _message;
  bool _biometricTried = false;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    if (settings.pinEnabled) {
      _method = AuthMethod.pin;
    } else {
      _method = AuthMethod.pattern;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

  Future<void> _tryBiometric() async {
    final settings = ref.read(settingsProvider);
    if (!settings.biometricEnabled || _biometricTried) return;
    _biometricTried = true;
    final auth = ref.read(authenticationServiceProvider);
    if (!await auth.canUseBiometrics()) return;
    setState(() => _method = AuthMethod.biometric);
    final result = await auth.authenticateBiometric();
    if (!mounted) return;
    if (result == UnlockResult.success) {
      ref.read(appLockProvider.notifier).unlock();
      return;
    }
    setState(() => _method = settings.pinEnabled ? AuthMethod.pin : AuthMethod.pattern);
  }

  void _feedback(String message) {
    setState(() {
      _error = true;
      _shake = true;
      _message = message;
      _pin = '';
    });
    HapticFeedback.heavyImpact();
    Future<void>.delayed(const Duration(milliseconds: 420), () {
      if (mounted) setState(() => _shake = false);
    });
  }

  Future<void> _handle(UnlockResult result) async {
    final l10n = context.l10n;
    switch (result) {
      case UnlockResult.success:
        ref.read(appLockProvider.notifier).unlock();
      case UnlockResult.failed:
        _feedback(l10n.noMatch);
      case UnlockResult.cancelled:
        setState(() => _method = ref.read(settingsProvider).pinEnabled ? AuthMethod.pin : AuthMethod.pattern);
      case UnlockResult.lockedOut:
        final left = ref.read(authenticationServiceProvider).lockoutRemaining;
        _feedback(l10n.tooManyAttempts(left?.inSeconds ?? 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            children: [
              const BrandMark(size: 72),
              const SizedBox(height: 22),
              Text(l10n.lockTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                _method == AuthMethod.biometric
                    ? l10n.lockBiometricHint
                    : _method == AuthMethod.pin
                        ? l10n.lockPinHint
                        : l10n.lockPatternHint,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: Shake(
                  play: _shake,
                  child: _method == AuthMethod.pattern
                      ? Center(
                          child: PatternLock(
                            error: _error,
                            onComplete: (pattern) async {
                              final result =
                                  await ref.read(authenticationServiceProvider).verifyPattern(pattern);
                              await _handle(result);
                            },
                          ),
                        )
                      : _method == AuthMethod.biometric
                          ? Center(
                              child: IconButton(
                                iconSize: 88,
                                onPressed: _tryBiometric,
                                icon: Icon(Icons.fingerprint_rounded, color: colors.accent, size: 88),
                              ),
                            )
                          : PinKeypad(
                              length: _pin.length,
                              maxLength: AppConstants.pinMaxLength,
                              error: _error,
                              onBiometric: settings.biometricEnabled
                                  ? () {
                                      _biometricTried = false;
                                      _tryBiometric();
                                    }
                                  : null,
                              onDigit: (d) async {
                                if (_pin.length >= AppConstants.pinMaxLength) return;
                                setState(() {
                                  _error = false;
                                  _message = null;
                                  _pin += d;
                                });
                                if (_pin.length >= AppConstants.pinMinLength) {
                                  final result =
                                      await ref.read(authenticationServiceProvider).verifyPin(_pin);
                                  if (result == UnlockResult.success ||
                                      _pin.length >= AppConstants.pinMaxLength ||
                                      result == UnlockResult.lockedOut) {
                                    await _handle(result);
                                  }
                                }
                              },
                              onBackspace: () {
                                if (_pin.isEmpty) return;
                                setState(() => _pin = _pin.substring(0, _pin.length - 1));
                              },
                            ),
                ),
              ),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_message!, style: TextStyle(color: colors.disarmed, fontWeight: FontWeight.w600)),
                ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                children: [
                  if (settings.pinEnabled && _method != AuthMethod.pin)
                    TextButton(
                      onPressed: () => setState(() {
                        _error = false;
                        _pin = '';
                        _method = AuthMethod.pin;
                      }),
                      child: Text(l10n.usePin),
                    ),
                  if (settings.patternEnabled && _method != AuthMethod.pattern)
                    TextButton(
                      onPressed: () => setState(() {
                        _error = false;
                        _method = AuthMethod.pattern;
                      }),
                      child: Text(l10n.usePattern),
                    ),
                  if (settings.biometricEnabled && _method != AuthMethod.biometric)
                    TextButton(
                      onPressed: () {
                        _biometricTried = false;
                        _tryBiometric();
                      },
                      child: Text(l10n.useFingerprint),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
