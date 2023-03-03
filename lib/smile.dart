import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Smile extends StatefulWidget {
  const Smile({Key? key}) : super(key: key);

  @override
  State<Smile> createState() => _SmileState();
}

class _SmileState extends State<Smile> {
  Offset _pointerPosition = Offset.zero;

  void updateLocation(PointerHoverEvent pointer) {
    setState(() {
      _pointerPosition = pointer.position;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    Offset center = Offset(screenSize.width / 2, screenSize.height / 2);

    return Scaffold(
      body: MouseRegion(
          onHover: updateLocation,
          child: Stack(
            children: [
              Center(
                child: CustomPaint(
                  painter: FacePaint(),
                  child: CustomPaint(
                    painter: EyeBallPainter(),
                  ),
                ),
              ),
              Positioned(
                top: center.dx - 60,
                left: center.dy - 60,
                child: Transform.translate(
                  offset: _calculatePointerOffset(
                    _pointerPosition,
                    center.translate(-60, -60),
                    30,
                  ),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Offset _calculatePointerOffset(
    Offset pointerPosition,
    Offset eyeballPosition,
    double maxOffset,
  ) {
    final eyeballCenter = Offset(
      eyeballPosition.dx + maxOffset,
      eyeballPosition.dy + maxOffset,
    ); // center of eyeball circle

    // calculate the angle between the pointer position and the eyeball center
    final dx = pointerPosition.dx - eyeballCenter.dx;
    final dy = pointerPosition.dy - eyeballCenter.dy;
    final angle = atan2(dy, dx);

    // calculate the offset of the pointer based on the angle and the maximum offset
    final offset = min(sqrt(dx * dx + dy * dy), maxOffset);
    final offsetX = offset * cos(angle);
    final offsetY = offset * sin(angle);

    return Offset(offsetX, offsetY);
  }
}

class FacePaint extends CustomPainter {
  Paint facePaint = Paint()
    ..color = Colors.yellowAccent
    ..style = PaintingStyle.fill;
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 150, facePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class EyeBallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint eyePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
    Offset eyePointer = Offset(size.width / 2 - 30, size.height / 2 - 30);
    canvas.translate(eyePointer.dx, eyePointer.dy);
    canvas.drawCircle(eyePointer, 30, eyePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
