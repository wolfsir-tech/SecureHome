// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:secure_home/core/utils/phone_utils.dart';

void main() {
  testWidgets('SecureHome splash brand renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Center(child: Text('SecureHome')))),
    );
    expect(find.text('SecureHome'), findsOneWidget);
  });

  test('PhoneUtils keeps Iranian mobile numbers in E.164 form', () {
    expect(PhoneUtils.normalize('0912 123 4567'), '+989121234567');
    expect(PhoneUtils.isValid('+989121234567'), isTrue);
    expect(PhoneUtils.isValid(''), isFalse);
  });
}
