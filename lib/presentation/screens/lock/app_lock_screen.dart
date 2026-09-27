import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/theme/app_shadows.dart';
import 'package:secure_home/domain/entities/auth_method.dart';
import 'package:secure_home/l10n/l10n.dart';
import 'package:secure_home/presentation/providers/app_lock_provider.dart';
import 'package:secure_home/presentation/providers/providers.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';
import 'package:secure_home/presentation/widgets/brand_mark.dart';
import 'package:secure_home/presentation/widgets/pattern_lock.dart';
import 'package:secure_home/presentation/widgets/pin_keypad.dart';
import 'package:secure_home/presentation/widgets/shake.dart';
import 'package:secure_home/presentation/widgets/soft_key.dart';

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
              _BrandPlinth(),
              const SizedBox(height: AppSpacing.xl),
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
              const SizedBox(height: AppSpacing.xxl),
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
                              child: SoftKey(
                                icon: Icons.fingerprint_rounded,
                                size: 96,
                                onTap: _tryBiometric,
                                semanticsLabel: l10n.useFingerprint,
                                color: colors.accent,
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
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(_message!, style: TextStyle(color: colors.disarmed, fontWeight: FontWeight.w600)),
                ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.sm,
                children: [
                  if (settings.pinEnabled && _method != AuthMethod.pin)
                    _MethodChip(
                      label: l10n.usePin,
                      onTap: () => setState(() {
                        _error = false;
                        _pin = '';
                        _method = AuthMethod.pin;
                      }),
                    ),
                  if (settings.patternEnabled && _method != AuthMethod.pattern)
                    _MethodChip(
                      label: l10n.usePattern,
                      onTap: () => setState(() {
                        _error = false;
                        _method = AuthMethod.pattern;
                      }),
                    ),
                  if (settings.biometricEnabled && _method != AuthMethod.biometric)
                    _MethodChip(
                      label: l10n.useFingerprint,
                      onTap: () {
                        _biometricTried = false;
                        _tryBiometric();
                      },
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

/// Brand mark placed on a soft raised plinth.
class _BrandPlinth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.border),
        boxShadow: AppShadows.raisedSm(colors),
      ),
      child: const BrandMark(size: 72),
    );
  }
}

/// Flat, quiet pill for switching the unlock method (Section 18 / Section 38).
class _MethodChip extends StatelessWidget {
  const _MethodChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surfaceHigh,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: colors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
