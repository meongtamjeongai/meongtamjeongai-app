import 'package:flutter/material.dart';
import 'dart:math';

class ResultVisualization extends StatelessWidget {
  final int score;

  const ResultVisualization({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 100),
      painter: _GaugePainter(score: score),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final int score;

  _GaugePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint basePaint =
        Paint()
          ..color = Colors.grey.shade300
          ..strokeWidth = 24
          ..style = PaintingStyle.stroke;

    final Paint arcPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Colors.lightBlue, Colors.blue, Colors.red],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..strokeWidth = 24
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      basePaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * (score / 100),
      false,
      arcPaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: '$score%',
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final offset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - radius / 2.2,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
