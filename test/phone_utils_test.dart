import 'package:flutter_test/flutter_test.dart';
import 'package:secure_home/core/constants/alarm_commands.dart';
import 'package:secure_home/core/utils/phone_utils.dart';

void main() {
  test('normalizes Iranian local numbers', () {
    expect(PhoneUtils.normalize('09121234567'), '+989121234567');
    expect(PhoneUtils.normalize('+98 912 123 4567'), '+989121234567');
  });

  test('masks numbers for display', () {
    expect(PhoneUtils.mask('+989121234567'), '+98 *** *** 4567');
  });

  test('rejects short numbers', () {
    expect(PhoneUtils.normalize('123'), isNull);
  });

  test('alarm commands are exact', () {
    expect(AlarmCommands.arm, 'P123456P11');
    expect(AlarmCommands.disarm, 'P123456P0');
  });
}
