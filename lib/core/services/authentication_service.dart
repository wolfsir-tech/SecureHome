import 'package:local_auth/local_auth.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/errors/app_exception.dart';
import 'package:secure_home/domain/entities/auth_method.dart';
import 'package:secure_home/domain/repositories/auth_repository.dart';

class AuthenticationService {
  AuthenticationService(this._authRepository, {LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  final AuthRepository _authRepository;
  final LocalAuthentication _localAuth;

  int _failures = 0;
  DateTime? _lockoutUntil;

  bool get isLockedOut {
    final until = _lockoutUntil;
    if (until == null) return false;
    if (DateTime.now().isBefore(until)) return true;
    _lockoutUntil = null;
    _failures = 0;
    return false;
  }

  Duration? get lockoutRemaining {
    final until = _lockoutUntil;
    if (until == null) return null;
    final left = until.difference(DateTime.now());
    return left.isNegative ? null : left;
  }

  Future<bool> canUseBiometrics() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      if (!supported) return false;
      final canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) return false;
      final types = await _localAuth.getAvailableBiometrics();
      return types.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<UnlockResult> authenticateBiometric({
    String reason = 'Unlock SecureHome',
  }) async {
    if (isLockedOut) return UnlockResult.lockedOut;
    try {
      final ok = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
      );
      if (ok) {
        _failures = 0;
        return UnlockResult.success;
      }
      return UnlockResult.cancelled;
    } catch (_) {
      return UnlockResult.failed;
    }
  }

  Future<void> setPin(String pin) async {
    _assertPin(pin);
    await _authRepository.setPin(pin);
  }

  Future<UnlockResult> verifyPin(String pin) async {
    if (isLockedOut) return UnlockResult.lockedOut;
    final ok = await _authRepository.verifyPin(pin);
    return _register(ok);
  }

  Future<void> setPattern(List<int> pattern) async {
    if (pattern.length < AppConstants.patternMinLength) {
      throw const AuthException('Draw a longer pattern.');
    }
    await _authRepository.setPattern(pattern);
  }

  Future<UnlockResult> verifyPattern(List<int> pattern) async {
    if (isLockedOut) return UnlockResult.lockedOut;
    final ok = await _authRepository.verifyPattern(pattern);
    return _register(ok);
  }

  Future<void> clearCredentials() => _authRepository.clearCredentials();

  UnlockResult _register(bool ok) {
    if (ok) {
      _failures = 0;
      _lockoutUntil = null;
      return UnlockResult.success;
    }
    _failures += 1;
    if (_failures >= AppConstants.maxAuthAttempts) {
      _lockoutUntil = DateTime.now().add(AppConstants.lockoutDuration);
      return UnlockResult.lockedOut;
    }
    return UnlockResult.failed;
  }

  void _assertPin(String pin) {
    if (pin.length < AppConstants.pinMinLength ||
        pin.length > AppConstants.pinMaxLength ||
        !RegExp(r'^\d+$').hasMatch(pin)) {
      throw const AuthException('Choose a 4 to 6 digit PIN.');
    }
  }
}
