import 'package:secure_home/core/services/authentication_service.dart';
import 'package:secure_home/domain/entities/auth_method.dart';

class Authenticate {
  const Authenticate(this._auth);

  final AuthenticationService _auth;

  Future<UnlockResult> biometric() => _auth.authenticateBiometric();

  Future<UnlockResult> pin(String value) => _auth.verifyPin(value);

  Future<UnlockResult> pattern(List<int> value) => _auth.verifyPattern(value);
}
