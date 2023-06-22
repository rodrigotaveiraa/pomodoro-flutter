import 'package:flutter/material.dart';

class TriangleButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(size.width, size.height / 2);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.close();

    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final iconSize = size.width * 0.6;
    final iconOffset = Offset(size.width * 0.2, size.height * 0.2);
    final iconPath = Path()
      ..moveTo(0, iconSize / 2)
      ..lineTo(iconSize, 0)
      ..lineTo(0, -iconSize / 2)
      ..close();

    final transformMatrix = Matrix4.translationValues(iconOffset.dx, size.height / 2 - iconOffset.dy, 0);
    final transformedPath = iconPath.transform(transformMatrix.storage);
    canvas.drawPath(transformedPath, iconPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
