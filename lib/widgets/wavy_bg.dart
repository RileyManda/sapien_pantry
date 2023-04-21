import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sapienpantry/utils/constants.dart';

class WavyBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = pPrimaryColor;

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.7,
          size.width * 0.3, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.8,
          size.width * 0.6, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.7,
          size.width, size.height * 0.75)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

