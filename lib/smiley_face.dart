import 'dart:math';

import 'package:flutter/material.dart';

class Smiley extends StatefulWidget {
  const Smiley({Key? key}) : super(key: key);

  @override
  State<Smiley> createState() => _SmileyState();
}

class _SmileyState extends State<Smiley> {
  double pointerX = 0.0;
  double pointerY = 0.0;
  static const maxEyeBallDistance = 44;
  bool _isHovered = false;

  void updateLocation(PointerEvent event) {
    final mediaX = MediaQuery.of(context).size.width;
    final mediaY = MediaQuery.of(context).size.height;

    final percentPositionX = maxEyeBallDistance / mediaX;
    final percentPositionY = maxEyeBallDistance / mediaY;

    setState(() {
      pointerX = percentPositionX * event.position.dx - maxEyeBallDistance / 2;
      pointerY = percentPositionY * event.position.dy - maxEyeBallDistance / 2;
    });

    const maxPointerDistance = maxEyeBallDistance / 2;

    final pointerDistance = sqrt(pointerX * pointerX + pointerY * pointerY);

    if (pointerDistance > maxPointerDistance) {
      final angle = atan2(pointerY, pointerX);
      pointerX = cos(angle) * maxPointerDistance;
      pointerY = sin(angle) * maxPointerDistance;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        onHover: updateLocation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: Face(isHovered: _isHovered),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EyeBall(
                      offset: Offset(pointerX, pointerY),
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    EyeBall(
                      offset: Offset(pointerX, pointerY),
                    )
                  ],
                )
              ],
            ),
            MouseRegion(
              onEnter: (pointerHoverEvent) {
                _isHovered = true;
              },
              onExit: (pointerHoverEvent) {
                _isHovered = false;
              },
              child: Container(
                height: 75,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle),
                child: const Center(
                  child: Text(
                    'Hover over me',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EyeBall extends StatelessWidget {
  final Offset offset;

  const EyeBall({Key? key, required this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.black)),
      child: Transform.translate(
        offset: offset,
        child: CustomPaint(
          painter: Pointer(7),
        ),
      ),
    );
    //);
  }
}

class Pointer extends CustomPainter {
  final double radius;

  Pointer(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white
      ..blendMode = BlendMode.difference;
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center.translate(0.0, 4.0), 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Face extends CustomPainter {
  final bool isHovered;

  Face({required this.isHovered});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw the mouth
    final facePaint = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(0, 30), 150, facePaint);

    // Draw the nose
    final nosePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    canvas.drawCircle(center.translate(0.0, 60), 15, nosePaint);

    //Draw the smile
    final smilePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.redAccent[700]!
      ..strokeWidth = 10;
    if (isHovered) {
      canvas.drawArc(
          Rect.fromCircle(center: center.translate(0.0, 100), radius: 30),
          0,
          3.14,
          false,
          smilePaint);
    } else {
      canvas.drawRect(
          Rect.fromCenter(
              center: center.translate(0.0, 100), width: 60, height: 5),
          smilePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
