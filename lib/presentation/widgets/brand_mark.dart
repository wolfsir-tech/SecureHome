import 'package:flutter/material.dart';
import 'package:secure_home/core/theme/app_colors.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.surfaceHigh,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: colors.border),
      ),
      child: Icon(
        Icons.shield_rounded,
        color: colors.accent,
        size: size * 0.52,
      ),
    );
  }
}
