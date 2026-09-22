import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/domain/entities/auth_method.dart';
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
  String _phase = 'auth';
  String _pin = '';
  String _newPin = '';
  List<int> _pattern = [];
  String? _error;
  late String _target;

  @override
  void initState() {
    super.initState();
    _target = widget.focus == 'pattern' ? 'pattern' : 'pin';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = _target == 'pattern' ? 'Change pattern' : 'Change PIN';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          children: [
            Text(
              _phase == 'auth'
                  ? 'Confirm it is you'
                  : _phase == 'create'
                      ? (_target == 'pin' ? 'Choose a new PIN' : 'Draw a new pattern')
                      : (_target == 'pin' ? 'Confirm your new PIN' : 'Confirm your new pattern'),
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
    if (_target == 'pin') {
      return Column(
        children: [
          PinKeypad(
            length: _pin.length,
            maxLength: AppConstants.pinMaxLength,
            onDigit: (d) async {
              if (_pin.length >= AppConstants.pinMaxLength) return;
              setState(() => _pin += d);
              if (_phase == 'auth' && _pin.length >= AppConstants.pinMinLength) {
                final result = await ref.read(authenticationServiceProvider).verifyPin(_pin);
                if (result == UnlockResult.success) {
                  setState(() {
                    _phase = 'create';
                    _pin = '';
                    _error = null;
                  });
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
          ),
          const SizedBox(height: 16),
          if (_phase != 'auth')
            PrimaryButton(
              label: _phase == 'create' ? 'Continue' : 'Save PIN',
              onPressed: _pin.length < AppConstants.pinMinLength
                  ? null
                  : () async {
                      if (_phase == 'create') {
                        setState(() {
                          _newPin = _pin;
                          _pin = '';
                          _phase = 'confirm';
                        });
                        return;
                      }
                      if (_pin != _newPin) {
                        setState(() {
                          _error = 'Those PINs did not match.';
                          _pin = '';
                        });
                        return;
                      }
                      await ref.read(authenticationServiceProvider).setPin(_pin);
                      await ref.read(settingsProvider.notifier).setPinEnabled(true);
                      if (mounted) context.pop();
                    },
            ),
        ],
      );
    }

    return Center(
      child: PatternLock(
        error: _error != null,
        onComplete: (pattern) async {
          if (_phase == 'auth') {
            final result = await ref.read(authenticationServiceProvider).verifyPattern(pattern);
            if (result == UnlockResult.success) {
              setState(() {
                _phase = 'create';
                _error = null;
              });
            } else {
              setState(() => _error = 'That did not match. Try again.');
            }
            return;
          }
          if (pattern.length < AppConstants.patternMinLength) {
            setState(() => _error = 'Connect at least 4 dots.');
            return;
          }
          if (_phase == 'create') {
            setState(() {
              _pattern = pattern;
              _phase = 'confirm';
              _error = null;
            });
            return;
          }
          if (pattern.join() != _pattern.join()) {
            setState(() => _error = 'Those patterns did not match.');
            return;
          }
          await ref.read(authenticationServiceProvider).setPattern(pattern);
          await ref.read(settingsProvider.notifier).setPatternEnabled(true);
          if (mounted) context.pop();
        },
      ),
    );
  }
}
