import 'package:flutter/material.dart';

/// The SecureHome logo. Renders the brand asset on its own background so it
/// looks the same on the splash, lock, onboarding and about screens.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.22),
      child: Image.asset(
        'assets/securehome.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
