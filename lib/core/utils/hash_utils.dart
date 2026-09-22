import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class HashUtils {
  static String randomSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  static String hashSecret(String secret, String salt) {
    final bytes = utf8.encode('$salt::$secret');
    return sha256.convert(bytes).toString();
  }

  static bool verify(String secret, String salt, String expectedHash) {
    return hashSecret(secret, salt) == expectedHash;
  }
}
