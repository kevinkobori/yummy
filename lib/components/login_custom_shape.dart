import 'package:flutter/material.dart';
import 'package:yummy/utils/constants.dart';

class LoginCustomShape extends CustomPainter {
  final double curveHeight;

  const LoginCustomShape(this.curveHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.azulClaro
      ..strokeWidth = 0.0;

    var path = Path()
      ..lineTo(0, curveHeight + 80)
      ..quadraticBezierTo(size.width / 4, 360, size.width, curveHeight)
      ..lineTo(200, curveHeight + 40)
      ..quadraticBezierTo(size.width / 2, 320, size.width, curveHeight)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawShadow(path, AppColors.azulClaro.withOpacity(0.3), 6.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
