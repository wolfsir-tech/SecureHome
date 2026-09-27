import 'dart:math' as math;

import 'package:flutter/material.dart';

class Shake extends StatefulWidget {
  const Shake({super.key, required this.child, required this.play});

  final Widget child;
  final bool play;

  @override
  State<Shake> createState() => _ShakeState();
}

class _ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void didUpdateWidget(covariant Shake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play && !oldWidget.play) {
      // Respect prefers-reduced-motion (Section 25).
      _controller.forward(from: 0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _allowAnimation = !MediaQuery.disableAnimationsOf(context);
  }

  bool _allowAnimation = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (!_allowAnimation) return child!;
        final dx = math.sin(_controller.value * math.pi * 6) * 8 * (1 - _controller.value);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: widget.child,
    );
  }
}
