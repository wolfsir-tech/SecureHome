import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_home/core/theme/app_colors.dart';

class PatternLock extends StatefulWidget {
  const PatternLock({
    super.key,
    required this.onComplete,
    this.error = false,
    this.size = 280,
  });

  final ValueChanged<List<int>> onComplete;
  final bool error;
  final double size;

  @override
  State<PatternLock> createState() => PatternLockState();
}

class PatternLockState extends State<PatternLock> {
  final List<int> _selected = [];
  Offset? _finger;
  final List<Offset> _cells = List.filled(9, Offset.zero);

  void reset() {
    setState(() {
      _selected.clear();
      _finger = null;
    });
  }

  int? _hit(Offset local) {
    for (var i = 0; i < 9; i++) {
      if ((_cells[i] - local).distance <= 28) return i;
    }
    return null;
  }

  void _select(int index) {
    if (_selected.contains(index)) return;
    if (_selected.isNotEmpty) {
      final last = _selected.last;
      final mid = _midpoint(last, index);
      if (mid != null && !_selected.contains(mid)) {
        _selected.add(mid);
      }
    }
    _selected.add(index);
    HapticFeedback.selectionClick();
  }

  int? _midpoint(int a, int b) {
    const pairs = {
      (0, 2): 1,
      (2, 0): 1,
      (3, 5): 4,
      (5, 3): 4,
      (6, 8): 7,
      (8, 6): 7,
      (0, 6): 3,
      (6, 0): 3,
      (1, 7): 4,
      (7, 1): 4,
      (2, 8): 5,
      (8, 2): 5,
      (0, 8): 4,
      (8, 0): 4,
      (2, 6): 4,
      (6, 2): 4,
    };
    return pairs[(a, b)];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final line = widget.error ? colors.disarmed : colors.accent;
    return Semantics(
      label: 'Pattern lock',
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: GestureDetector(
          onPanStart: (d) {
            setState(() {
              _selected.clear();
              _finger = d.localPosition;
              final hit = _hit(d.localPosition);
              if (hit != null) _select(hit);
            });
          },
          onPanUpdate: (d) {
            setState(() {
              _finger = d.localPosition;
              final hit = _hit(d.localPosition);
              if (hit != null) _select(hit);
            });
          },
          onPanEnd: (_) {
            final pattern = List<int>.from(_selected);
            setState(() => _finger = null);
            if (pattern.isNotEmpty) widget.onComplete(pattern);
          },
          child: CustomPaint(
            painter: _PatternPainter(
              selected: _selected,
              finger: _finger,
              cells: _cells,
              color: line,
              muted: colors.border,
              fill: colors.surfaceHigh,
            ),
          ),
        ),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  _PatternPainter({
    required this.selected,
    required this.finger,
    required this.cells,
    required this.color,
    required this.muted,
    required this.fill,
  });

  final List<int> selected;
  final Offset? finger;
  final List<Offset> cells;
  final Color color;
  final Color muted;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    const gap = 3;
    final cell = size.shortestSide / gap;
    for (var i = 0; i < 9; i++) {
      final row = i ~/ 3;
      final col = i % 3;
      cells[i] = Offset(col * cell + cell / 2, row * cell + cell / 2);
    }

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (selected.isNotEmpty) {
      final path = Path()..moveTo(cells[selected.first].dx, cells[selected.first].dy);
      for (var i = 1; i < selected.length; i++) {
        path.lineTo(cells[selected[i]].dx, cells[selected[i]].dy);
      }
      if (finger != null) path.lineTo(finger!.dx, finger!.dy);
      canvas.drawPath(path, linePaint);
    }

    for (var i = 0; i < 9; i++) {
      final active = selected.contains(i);
      final paint = Paint()
        ..color = active ? color.withValues(alpha: 0.18) : fill
        ..style = PaintingStyle.fill;
      canvas.drawCircle(cells[i], 22, paint);
      final ring = Paint()
        ..color = active ? color : muted
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(cells[i], 22, ring);
      canvas.drawCircle(cells[i], active ? 8 : 5, Paint()..color = active ? color : muted);
    }
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) => true;
}
