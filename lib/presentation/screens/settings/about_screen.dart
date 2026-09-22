import 'package:flutter/material.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/presentation/widgets/brand_mark.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          const Center(child: BrandMark(size: 84)),
          const SizedBox(height: 16),
          Center(child: Text(AppConstants.appName, style: Theme.of(context).textTheme.headlineMedium)),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Version ${AppConstants.version}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
            ),
          ),
          const SizedBox(height: 28),
          Text('Privacy information', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Text(
            'SecureHome works entirely on this device. It does not create an account and does not talk to a server. Alarm commands are sent as SMS to the number you save. Your PIN and pattern are stored only as one-way hashes in secure storage.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted, height: 1.45),
          ),
        ],
      ),
    );
  }
}
