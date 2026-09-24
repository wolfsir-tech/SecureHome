import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/domain/entities/auth_method.dart';
import 'package:secure_home/l10n/l10n.dart';
import 'package:secure_home/presentation/providers/providers.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';
import 'package:secure_home/presentation/widgets/pattern_lock.dart';
import 'package:secure_home/presentation/widgets/pin_keypad.dart';
import 'package:secure_home/presentation/widgets/primary_button.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key, this.focus});

  final String? focus;

  @override
  ConsumerState<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen> {
  static const _phaseAuth = 'auth';
  static const _phaseCreate = 'create';
  static const _phaseConfirm = 'confirm';

  String _phase = _phaseAuth;
  String _pin = '';
  String _newPin = '';
  List<int> _pattern = [];
  String? _error;
  bool _busy = false;
  late String _target;
  final _patternKey = GlobalKey<PatternLockState>();

  @override
  void initState() {
    super.initState();
    _target = widget.focus == 'pattern' ? 'pattern' : 'pin';
  }

  bool get _isPin => _target == 'pin';

  void _fail(String message) {
    setState(() {
      _error = message;
      _busy = false;
    });
    _patternKey.currentState?.reset();
  }

  Future<void> _verifyAndCreate() async {
    final l10n = context.l10n;
    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = ref.read(authenticationServiceProvider);
    final result = _isPin ? await auth.verifyPin(_pin) : await auth.verifyPattern(_pattern);
    if (!mounted) return;
    switch (result) {
      case UnlockResult.success:
        setState(() {
          _phase = _phaseCreate;
          _error = null;
          _busy = false;
          _pin = '';
          _pattern = [];
        });
        _patternKey.currentState?.reset();
      case UnlockResult.failed:
        _fail(l10n.noMatch);
        setState(() {
          _pin = '';
          _pattern = [];
        });
      case UnlockResult.cancelled:
        setState(() {
          _error = null;
          _busy = false;
        });
      case UnlockResult.lockedOut:
        final left = ref.read(authenticationServiceProvider).lockoutRemaining;
        _fail(l10n.tooManyAttempts(left?.inSeconds ?? AppConstants.lockoutDuration.inSeconds));
        setState(() {
          _pin = '';
          _pattern = [];
        });
    }
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    if (_isPin) {
      if (_pin != _newPin) {
        _fail(l10n.pinsNoMatch);
        setState(() {
          _pin = '';
        });
        return;
      }
      try {
        await ref.read(authenticationServiceProvider).setPin(_pin);
      } catch (_) {
        _fail(l10n.choosePinLength);
        return;
      }
      await ref.read(settingsProvider.notifier).setPinEnabled(true);
    } else {
      if (_pattern.length < AppConstants.patternMinLength) {
        _fail(l10n.patternTooShort);
        return;
      }
      try {
        await ref.read(authenticationServiceProvider).setPattern(_pattern);
      } catch (_) {
        _fail(l10n.patternTooShort);
        return;
      }
      await ref.read(settingsProvider.notifier).setPatternEnabled(true);
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final title = _isPin ? l10n.changePin : l10n.changePattern;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          children: [
            Text(
              _phase == _phaseAuth
                  ? l10n.confirmIdentity
                  : _phase == _phaseCreate
                      ? (_isPin ? l10n.chooseNewPin : l10n.drawNewPattern)
                      : (_isPin ? l10n.confirmNewPin : l10n.confirmNewPattern),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: TextStyle(color: colors.disarmed)),
              ),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    final l10n = context.l10n;
    if (_isPin) {
      return Column(
        children: [
          PinKeypad(
            length: _pin.length,
            maxLength: AppConstants.pinMaxLength,
            error: _error != null,
            onDigit: (d) {
              if (_pin.length >= AppConstants.pinMaxLength) return;
              setState(() {
                _pin += d;
                _error = null;
              });
            },
            onBackspace: () {
              if (_pin.isEmpty) return;
              setState(() {
                _pin = _pin.substring(0, _pin.length - 1);
                _error = null;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: PrimaryButton(
                label: _phase == _phaseAuth
                    ? l10n.continueButton
                    : _phase == _phaseCreate
                        ? l10n.continueButton
                        : l10n.savePin,
                loading: _busy,
                onPressed: _busy || _pin.length < AppConstants.pinMinLength
                    ? null
                    : () async {
                        if (_phase == _phaseAuth) {
                          await _verifyAndCreate();
                          return;
                        }
                        if (_phase == _phaseCreate) {
                          setState(() {
                            _newPin = _pin;
                            _pin = '';
                            _phase = _phaseConfirm;
                            _error = null;
                          });
                          return;
                        }
                        await _save();
                      },
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: Center(
            child: PatternLock(
              key: _patternKey,
              error: _error != null,
              onComplete: (pattern) async {
                setState(() => _error = null);
                if (_phase == _phaseAuth) {
                  _pattern = pattern;
                  await _verifyAndCreate();
                  return;
                }
                if (pattern.length < AppConstants.patternMinLength) {
                  _fail(l10n.patternTooShort);
                  return;
                }
                if (_phase == _phaseCreate) {
                  setState(() {
                    _pattern = pattern;
                    _phase = _phaseConfirm;
                    _error = null;
                  });
                  _patternKey.currentState?.reset();
                  return;
                }
                if (pattern.join('-') != _pattern.join('-')) {
                  _fail(l10n.patternsNoMatch);
                  return;
                }
                await _save();
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            _phase == _phaseCreate ? l10n.drawNewPattern : l10n.confirmNewPattern,
            style: TextStyle(color: context.colors.textMuted),
          ),
        ),
      ],
    );
  }
}
