import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: CustomPaint(
        size: Size.square(size),
        painter: _LogoPainter(Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color primaryColor;

  _LogoPainter(this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [primaryColor, const Color(0xFF10B981)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final paintBase = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // The abstracted "A" peak
    final pathPaint = Paint()
      ..shader = paintBase.shader
      ..style = paintBase.style
      ..strokeCap = paintBase.strokeCap
      ..strokeJoin = paintBase.strokeJoin
      ..strokeWidth = size.width * 0.125;

    final peakPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.5, size.height * 0.125)
      ..lineTo(size.width, size.height);

    canvas.drawPath(peakPath, pathPaint);

    // The crossbar
    final linePaint = Paint()
      ..shader = paintBase.shader
      ..style = paintBase.style
      ..strokeCap = paintBase.strokeCap
      ..strokeJoin = paintBase.strokeJoin
      ..strokeWidth = size.width * 0.10;

    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.625),
      Offset(size.width * 0.7, size.height * 0.625),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
