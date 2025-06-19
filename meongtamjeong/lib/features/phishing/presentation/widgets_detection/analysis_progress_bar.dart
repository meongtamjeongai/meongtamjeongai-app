import 'package:flutter/material.dart';
import 'dart:math';

class AnalysisProgressBar extends StatelessWidget {
  final double percentage;

  const AnalysisProgressBar({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 120,
      child: CustomPaint(
        painter: _GaugePainter(percentage),
        child: Center(
          child: Text(
            '${percentage.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double percentage;

  _GaugePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    const startAngle = pi;
    const sweepAngle = pi;

    final basePaint =
        Paint()
          ..color = Colors.grey.shade300
          ..strokeWidth = 16
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final progressPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
          ).createShader(
            Rect.fromCircle(center: size.center(Offset.zero), radius: 100),
          )
          ..strokeWidth = 16
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      basePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * (percentage / 100),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
