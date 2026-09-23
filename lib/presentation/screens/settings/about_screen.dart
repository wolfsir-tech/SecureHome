import 'package:flutter/material.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/l10n/l10n.dart';
import 'package:secure_home/presentation/widgets/brand_mark.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          const Center(child: BrandMark(size: 84)),
          const SizedBox(height: 16),
          Center(child: Text(AppConstants.appName, style: Theme.of(context).textTheme.headlineMedium)),
          const SizedBox(height: 4),
          Center(
            child: Text(
              l10n.version(AppConstants.version),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
            ),
          ),
          const SizedBox(height: 28),
          Text(l10n.privacyTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Text(
            l10n.privacyBody,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted, height: 1.45),
          ),
        ],
      ),
    );
  }
}
