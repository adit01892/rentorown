import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0052FF), Color(0xFF2A7BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      alignment: Alignment.center,
      child: CustomPaint(size: Size.square(size), painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // House: roof + body + door. Kept intentionally geometric and minimal.
    final house = Path()
      ..moveTo(size.width * 0.22, size.height * 0.52)
      ..lineTo(size.width * 0.50, size.height * 0.28)
      ..lineTo(size.width * 0.78, size.height * 0.52)
      ..moveTo(size.width * 0.30, size.height * 0.50)
      ..lineTo(size.width * 0.30, size.height * 0.76)
      ..lineTo(size.width * 0.70, size.height * 0.76)
      ..lineTo(size.width * 0.70, size.height * 0.50)
      ..moveTo(size.width * 0.50, size.height * 0.76)
      ..lineTo(size.width * 0.50, size.height * 0.60);

    canvas.drawPath(house, paint);

    // Key: ring + shaft + tooth, offset to suggest "rent".
    final keyRingCenter = Offset(size.width * 0.27, size.height * 0.32);
    canvas.drawCircle(keyRingCenter, size.width * 0.10, paint);

    final key = Path()
      ..moveTo(size.width * 0.34, size.height * 0.32)
      ..lineTo(size.width * 0.58, size.height * 0.32)
      ..moveTo(size.width * 0.52, size.height * 0.32)
      ..lineTo(size.width * 0.52, size.height * 0.42)
      ..lineTo(size.width * 0.58, size.height * 0.42);

    canvas.drawPath(key, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
