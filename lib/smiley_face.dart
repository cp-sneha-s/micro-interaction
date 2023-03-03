import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class CursorBlending extends StatefulWidget {
//   @override
//   _CursorBlendingState createState() => _CursorBlendingState();
// }
//
// class _CursorBlendingState extends State<CursorBlending>
//     with SingleTickerProviderStateMixin {
//   late Offset pointerOffset;
//   late AnimationController pointerSizeController;
//   late Animation<double> pointerAnimation;
//   @override
//   void initState() {
//     pointerOffset = Offset(0.0, 0.0);
//     pointerSizeController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 300));
//     pointerAnimation = CurvedAnimation(
//         curve: Curves.easeInOutCubic,
//         parent: Tween<double>(begin: 0, end: 1).animate(pointerSizeController));
//     super.initState();
//   }
//
//   void togglePointerSize(bool hovering) async {
//     if (hovering) {
//       pointerSizeController.forward();
//     } else
//       pointerSizeController.reverse();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: MouseRegion(
//         opaque: false,
//         cursor: SystemMouseCursors.none,
//         onHover: (e) => setState(() => pointerOffset = e.localPosition),
//         //onExit: (e) => setState(() => pointerOffset = null),
//         child: Stack(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: TextColumn(
//                     backgroundColor: Colors.black,
//                     textColor: Colors.white,
//                     onLinkHovered: togglePointerSize,
//                   ),
//                 ),
//                 Expanded(
//                   child: TextColumn(
//                     onLinkHovered: togglePointerSize,
//                   ),
//                 ),
//               ],
//             ),
//             if (pointerOffset != null) ...[
//               AnimatedBuilder(
//                   animation: pointerSizeController,
//                   builder: (context, snapshot) {
//                     return AnimatedPointer(
//                       pointerOffset: pointerOffset,
//                       radius: 45 + 100 * pointerAnimation.value,
//                     );
//                   }),
//               AnimatedPointer(
//                 pointerOffset: pointerOffset,
//                 movementDuration: const Duration(milliseconds: 200),
//                 radius: 10,
//               )
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TextColumn extends StatelessWidget {
//   const TextColumn({
//     Key? key,
//     required this.onLinkHovered,
//     this.textColor = Colors.black,
//     this.backgroundColor = Colors.white,
//   }) : super(key: key);
//
//   final Function(bool) onLinkHovered;
//   final Color textColor;
//   final Color backgroundColor;
//
//   TextStyle get _defaultTextStyle => TextStyle(color: textColor);
//   @override
//   Widget build(BuildContext context) {
//     return Ink(
//       width: double.infinity,
//       color: backgroundColor,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             'Hello',
//             style: _defaultTextStyle.copyWith(fontSize: 30),
//           ),
//           const SizedBox(height: 20),
//           Text('Check out this link:', style: _defaultTextStyle),
//           const SizedBox(height: 30),
//           InkWell(
//             focusColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             hoverColor: Colors.transparent,
//             splashColor: Colors.transparent,
//             onHover: onLinkHovered,
//             mouseCursor: SystemMouseCursors.none,
//             onTap: () => null,
//             child: Ink(
//               child: Column(
//                 children: [
//                   Text('See what happens', style: _defaultTextStyle),
//                   const SizedBox(height: 7),
//                   Container(color: textColor, width: 50, height: 2)
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class AnimatedPointer extends StatelessWidget {
//   const AnimatedPointer({
//     Key? key,
//     this.movementDuration = const Duration(milliseconds: 700),
//     this.radius = 30,
//     required this.pointerOffset,
//   }) : super(key: key);
//   final Duration movementDuration;
//   final Offset pointerOffset;
//   final double radius;
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedPositioned(
//       duration: movementDuration,
//       curve: Curves.easeOutExpo,
//       top: pointerOffset.dy,
//       left: pointerOffset.dx,
//       child: CustomPaint(
//         painter: Pointer(radius),
//       ),
//     );
//   }
// }
//
// // Multiple containers stacked on top of each other will block hover events
// // events, and the blending behaviour of an InkWell is a bit strange, so
// // I resorted to using a CustomPainter.
// class Pointer extends CustomPainter {
//   final double radius;
//
//   Pointer(this.radius);
//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawCircle(
//       Offset(0, 0),
//       radius,
//       Paint()
//         ..color = Colors.white
//         ..blendMode = BlendMode.difference,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

GlobalKey eyesBallKey = GlobalKey();
GlobalKey clickMeButtonkey = GlobalKey();

class SmileyFace extends StatefulWidget {
  const SmileyFace({Key? key}) : super(key: key);

  @override
  State<SmileyFace> createState() => _SmileyFaceState();
}

class _SmileyFaceState extends State<SmileyFace>
    with SingleTickerProviderStateMixin {
  bool enterInClickMe = false;
  double x = 0.0;
  double y = 0.0;
  double pointerX = 0.0;
  double pointerY = 0.0;
  late final AnimationController pointerSizeController;
  late final Animation pointerAnimation;
  double eyeballPositionX = 0.0;
  double eyeballPositionY = 0.0;

  @override
  void initState() {
    super.initState();
  }

  void updateLocation(PointerEvent event) {
    final mediaX = MediaQuery.of(context).size.width;
    final mediaY = MediaQuery.of(context).size.height;
    setState(() {
      x = event.position.dx;
      y = event.position.dy;
    });

    final RenderBox renderBox =
        eyesBallKey.currentContext?.findRenderObject() as RenderBox;
    final eyeballSize = renderBox.size;
    final eyeballOffset = renderBox.localToGlobal(Offset.zero);

    final percentPositionX = 40 * 100 / mediaX;
    final percentPositionY = 40 * 100 / mediaY;

    double finalX = percentPositionX * x / 100;
    double finalY = percentPositionY * y / 100;

    eyeballPositionX = (eyeballOffset.dx + eyeballSize.width) / 2;
    eyeballPositionY = (eyeballOffset.dy + eyeballSize.height) / 2;
    final dx = x - eyeballPositionX;
    final dy = y - eyeballPositionY;
    final angle = atan2(dy, dx);

    // calculate the offset of the pointer based on the angle and the maximum offset
    final offset = min(sqrt(dx * dx + dy * dy), 20);
    final offsetX = offset * cos(angle);
    final offsetY = offset * sin(angle);

    pointerX = finalX > offsetX ? offsetX : finalX;
    pointerY = finalY > offsetY ? offsetY : finalY;

    final RenderBox buttonBox =
        clickMeButtonkey.currentContext?.findRenderObject() as RenderBox;
    final buttonSize = buttonBox.size;
    final clickMeOffset = buttonBox.localToGlobal(Offset.zero);
    final startX = clickMeOffset.dx;
    final startY = clickMeOffset.dy;
    final endX = clickMeOffset.dx + buttonSize.width;
    final endY = clickMeOffset.dy + buttonSize.height;

    if ((x < endX && x > startX) && (y > startY && y < endY)) {
      enterInClickMe = true;
    } else {
      enterInClickMe = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        onHover: updateLocation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        painter: Lips(pointerIsAroundButton: enterInClickMe),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EyesBall(
                            key: eyesBallKey,
                            x: pointerX,
                            y: pointerY,
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          EyesBall(
                            x: pointerX,
                            y: pointerY,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                ],
              ),
              OutlinedButton(
                key: clickMeButtonkey,
                onPressed: () {
                  enterInClickMe = true;
                },
                child: const Text(
                  'Click me',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EyesBall extends StatelessWidget {
  const EyesBall({
    Key? key,
    required this.x,
    required this.y,
  }) : super(key: key);

  final double x;
  final double y;

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
          offset: Offset(x, y),
          child: CustomPaint(
            painter: Pointer(5),
          )),
    );
  }
}

class Lips extends CustomPainter {
  final bool pointerIsAroundButton;
  Lips({required this.pointerIsAroundButton});
  @override
  void paint(Canvas canvas, Size size) {
    const radius = 50.0;
    final center = Offset(size.width / 2, size.height / 2);

    // Draw the mouth
    final smilePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.redAccent[700]!
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    final facePaint = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.fill
      ..strokeWidth = 5;
    canvas.drawCircle(const Offset(0, 30), 150, facePaint);
    final nosePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    canvas.drawCircle(center.translate(0.0, 60), 15, nosePaint);

    if (pointerIsAroundButton) {
      canvas.drawArc(
          Rect.fromCircle(
              center: center.translate(0.0, 100), radius: radius / 1.5),
          0,
          3.14,
          false,
          smilePaint);
    } else {
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round
        ..color = Colors.redAccent[700]!;
      canvas.drawRect(
          Rect.fromCenter(
              center: center.translate(0.0, 100), width: 60, height: 10),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Multiple containers stacked on top of each other will block hover events
// events, and the blending behaviour of an InkWell is a bit strange, so
// I resorted to using a CustomPainter.
class Pointer extends CustomPainter {
  final double radius;

  Pointer(this.radius);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      radius,
      Paint()
        ..color = Colors.white
        ..blendMode = BlendMode.difference,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Smiley extends CustomPainter {
  late Paint _paintCircle;
  late Paint _paintDetails;
  late Paint _smilePaint;
  Smiley() {
    // face paint
    _paintCircle = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    // eyes and nose
    _paintDetails = Paint()
      ..color = Colors.redAccent[700]!
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    // smile
    _smilePaint = Paint()
      ..color = Colors.redAccent[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
//     drawing face background
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, _paintCircle);

//     drawing eyes
    canvas.drawCircle(
        Offset(size.width * 0.3, size.height * 0.3), 16, _paintDetails);
    canvas.drawCircle(Offset(size.width - size.width * 0.3, size.height * 0.3),
        16, _paintDetails);

    double x = size.width / 2;
    double y = size.height / 2;

    // drawing nose
    final Path path = Path();
    path.moveTo(x - 10, y);
    path.lineTo(y, y - 20);
    path.lineTo(x + 10, y);
    path.close();

    canvas.drawPath(path, _paintDetails);

    // drawing smile arc

    final smile = Path();
    smile.moveTo(size.width * 0.7, size.height * 0.7);
    smile.arcToPoint(Offset(size.width * 0.3, size.height * 0.7),
        radius: Radius.circular(70));
    canvas.drawPath(smile, _smilePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
