import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/domain/entities/alarm_state.dart';

class StatusRing extends StatefulWidget {
  const StatusRing({super.key, required this.status, this.size = 220});

  final AlarmStatus status;
  final double size;

  @override
  State<StatusRing> createState() => _StatusRingState();
}

class _StatusRingState extends State<StatusRing> with TickerProviderStateMixin {
  late final AnimationController _pulse;
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _sync(widget.status);
  }

  @override
  void didUpdateWidget(covariant StatusRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) _sync(widget.status);
  }

  void _sync(AlarmStatus status) {
    if (status.isBusy) {
      _spin.repeat();
    } else {
      _spin.stop();
      _spin.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final visual = _visualFor(widget.status, colors);
    return Semantics(
      label: visual.semantic,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulse, _spin]),
          builder: (context, _) {
            return CustomPaint(
              painter: _RingPainter(
                color: visual.color,
                track: colors.surfaceHigh,
                progress: widget.status.isBusy ? null : visual.progress,
                spin: _spin.value,
                pulse: 0.18 + (_pulse.value * 0.12),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child: Icon(
                    visual.icon,
                    key: ValueKey(widget.status),
                    size: widget.size * 0.28,
                    color: visual.color,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _StatusVisual _visualFor(AlarmStatus status, AppColors colors) {
    switch (status) {
      case AlarmStatus.secured:
        return _StatusVisual(
          icon: Icons.verified_user_rounded,
          color: colors.secured,
          progress: 1,
          semantic: 'Home is secured',
        );
      case AlarmStatus.disarmed:
        return _StatusVisual(
          icon: Icons.lock_open_rounded,
          color: colors.disarmed,
          progress: 1,
          semantic: 'Alarm is disarmed',
        );
      case AlarmStatus.activating:
      case AlarmStatus.deactivating:
      case AlarmStatus.sending:
        return _StatusVisual(
          icon: Icons.sync_rounded,
          color: colors.processing,
          semantic: 'Sending command',
        );
      case AlarmStatus.error:
        return _StatusVisual(
          icon: Icons.error_outline_rounded,
          color: colors.disarmed,
          progress: 0.2,
          semantic: 'Unable to send command',
        );
      case AlarmStatus.unknown:
        return _StatusVisual(
          icon: Icons.shield_outlined,
          color: colors.warning,
          progress: 0.35,
          semantic: 'Alarm status unknown',
        );
    }
  }
}

class _StatusVisual {
  const _StatusVisual({
    required this.icon,
    required this.color,
    required this.semantic,
    this.progress,
  });

  final IconData icon;
  final Color color;
  final String semantic;
  final double? progress;
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.color,
    required this.track,
    required this.pulse,
    required this.spin,
    this.progress,
  });

  final Color color;
  final Color track;
  final double pulse;
  final double spin;
  final double? progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 10;
    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final glow = Paint()
      ..color = color.withValues(alpha: pulse)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, radius, glow);

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(circle: center, radius: radius);
    if (progress != null) {
      canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * progress!, false, arcPaint);
    } else {
      canvas.drawArc(rect, spin * math.pi * 2, math.pi * 1.15, false, arcPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => true;
}
