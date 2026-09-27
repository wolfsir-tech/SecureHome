import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/theme/app_shadows.dart';
import 'package:secure_home/core/theme/app_theme.dart';
import 'package:secure_home/presentation/widgets/app_card.dart';
import 'package:secure_home/presentation/widgets/primary_button.dart';
import 'package:secure_home/presentation/widgets/soft_key.dart';

/// Renders the new Soft UI tokens and core components in both themes so a
/// broken decoration/shader silently crashes a test instead of reaching users.
void main() {
  for (final brightness in [Brightness.light, Brightness.dark]) {
    final isDark = brightness == Brightness.dark;

    testWidgets('Soft UI theme renders (${isDark ? 'dark' : 'light'})', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: isDark ? AppTheme.dark() : AppTheme.light(),
          home: Scaffold(
            body: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryButton(
                    label: 'Arm',
                    icon: Icons.security_rounded,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  GhostButton(label: 'Disarm', onPressed: () {}),
                  const SizedBox(height: 12),
                  const SoftKey(label: '5'),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Tokens are registered as a ThemeExtension and resolvable.
      final context = tester.element(find.byType(Scaffold));
      expect(Theme.of(context).extension<AppColors>(), isNotNull);
      expect(AppShadows.raised(context.colors), hasLength(2));
      expect(AppShadows.raisedSm(context.colors), hasLength(2));

      // Core components render.
      expect(find.text('Arm'), findsOneWidget);
      expect(find.text('Disarm'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
    });
  }

  test('Soft UI tokens have consistent geometry', () {
    expect(AppRadius.md, lessThanOrEqualTo(AppRadius.lg));
    expect(AppRadius.lg, lessThanOrEqualTo(AppRadius.xl));
    expect(AppSpacing.md, greaterThan(AppSpacing.sm));
    expect(AppTarget.button, greaterThanOrEqualTo(AppTarget.min));
    expect(AppTarget.key, greaterThanOrEqualTo(AppTarget.min));
  });
}
