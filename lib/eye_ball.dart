import 'dart:math' as math;

import 'package:flutter/material.dart';

class RollingEyes extends StatefulWidget {
  @override
  _RollingEyesState createState() => _RollingEyesState();
}

class _RollingEyesState extends State<RollingEyes> {
  Offset _position = Offset.zero;

  void _updatePosition(PointerEvent event) {
    setState(() {
      _position = event.position;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eyeballRadius = 25.0;
    final pointerRadius = 5.0;
    final maxAngle =
        math.pi / 6; // maximum angle in radians that the eyeball can rotate

    // calculate the angle of rotation based on the pointer position
    final dx = _position.dx - MediaQuery.of(context).size.width / 2;
    final dy = _position.dy - MediaQuery.of(context).size.height / 2;
    final distance = math.sqrt(dx * dx + dy * dy);
    final angle = math.asin(dy / distance).clamp(-maxAngle, maxAngle);
    final rotatedPosition = Offset(
        eyeballRadius * math.sin(angle), eyeballRadius * math.cos(angle));

    return MouseRegion(
      onHover: _updatePosition,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(
                rotatedPosition.dx, rotatedPosition.dy, 0),
            child: Container(
              width: eyeballRadius * 2,
              height: eyeballRadius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Transform.rotate(
                angle: angle,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: pointerRadius * 2,
                    height: pointerRadius * 2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
