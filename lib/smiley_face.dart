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

  @override
  void initState() {
    pointerSizeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    pointerAnimation = CurvedAnimation(
        curve: Curves.easeInOutCubic,
        parent: Tween<double>(begin: 0, end: 1).animate(pointerSizeController));
    super.initState();
  }

  void updateLocation(PointerEvent event) {
    setState(() {
      x = event.position.dx;
      y = event.position.dy;
    });

    final RenderBox renderBox =
        eyesBallKey.currentContext?.findRenderObject() as RenderBox;
    final eyeballSize = renderBox.size;
    final eyeballOffset = renderBox.localToGlobal(Offset.zero);

    final mediaX = MediaQuery.of(context).size.width;
    final mediaY = MediaQuery.of(context).size.height;

    print('total size of screen in X axis: $mediaX');
    print('total size of screen in Y axis: $mediaY');

    // print('Eyeball Offset XX Axis: ${eyeballOffset.dx}');
    // print('Eyeball Offset YY Axis: ${eyeballOffset.dy}');
    //
    // print(
    //     'Position: ${(eyeballOffset.dx + eyeballSize.width) / 2}, ${(eyeballOffset.dy + eyeballSize.height) / 2}');

    print('X axis : $x');
    print('Y Axis: $y');

    final percentPositionX = 40 * 100 / mediaX;
    final percentPositionY = 40 * 100 / mediaY;

    double finalX = percentPositionX * x / 100;
    double finalY = percentPositionY * y / 100;

    print('Final Position of X Axis: $finalX');
    print('Final Position of Y Axis: $finalY');

    final posiotionX = (eyeballOffset.dx + eyeballSize.width) / 2;
    final positionY = (eyeballOffset.dy + eyeballSize.height) / 2;

    pointerX = finalX - 20;
    pointerY = finalY - 20;

    bool isDotInside = pow(pointerX, 2) + pow(pointerY, 2) < pow(20, 2);

    final RenderBox buttonBox =
        clickMeButtonkey.currentContext?.findRenderObject() as RenderBox;
    final buttonSize = buttonBox.size;
    final clickMeOffset = buttonBox.localToGlobal(Offset.zero);
    final startX = clickMeOffset.dx;
    final startY = clickMeOffset.dy;
    final endX = clickMeOffset.dx + buttonSize.width;
    final endY = clickMeOffset.dy + buttonSize.height;
    final startPosition = Offset(startX, startY);
    final endPosition = Offset(endX, endY);
    if ((x < endX && x > startX) && (y > startY && y < endY)) {
      enterInClickMe = true;
    } else {
      enterInClickMe = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: updateLocation,
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(MediaQuery.of(context).size),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EyesBall(key: eyesBallKey, x: pointerX, y: pointerY),
                          const SizedBox(
                            width: 50,
                          ),
                          EyesBall(x: pointerX, y: pointerY),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      CustomPaint(
                        painter: Lips(pointerIsAroundButton: enterInClickMe),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                    ],
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
    return Stack(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.redAccent[700]!, width: 5)),
        ),
        AnimatedPointer(
          pointerOffset: Offset(x, y),
          radius: 6,
        ),
      ],
    );
  }
}

class AnimatedPointer extends StatelessWidget {
  const AnimatedPointer({
    Key? key,
    this.movementDuration = const Duration(milliseconds: 700),
    this.radius = 30,
    required this.pointerOffset,
  }) : super(key: key);
  final Duration movementDuration;
  final Offset pointerOffset;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: movementDuration,
      curve: Curves.easeOutExpo,
      top: pointerOffset.dy,
      left: pointerOffset.dx,
      child: CustomPaint(
        painter: Pointer(
          radius,
        ),
        child: const SizedBox(
          height: 60,
          width: 60,
        ),
      ),
    );
  }
}

class Lips extends CustomPainter {
  final bool pointerIsAroundButton;
  Lips({required this.pointerIsAroundButton});
  @override
  void paint(Canvas canvas, Size size) {
    const radius = 50.0;
    final center = Offset(size.width / 2, size.height / 2 + 30);

    // Draw the mouth
    final smilePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.redAccent[700]!
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    canvas.drawCircle(Offset(0, size.height - 40), 150, smilePaint);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.redAccent[700]!;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2 - 10), 15, paint);

    if (pointerIsAroundButton) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius / 1.5), 0,
          3.14, false, smilePaint);
    } else {
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round
        ..color = Colors.redAccent[700]!;
      canvas.drawRect(
          Rect.fromCenter(center: center, width: 60, height: 10), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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
    final Path _path = Path();
    _path.moveTo(x - 10, y);
    _path.lineTo(y, y - 20);
    _path.lineTo(x + 10, y);
    _path.close();

    canvas.drawPath(_path, _paintDetails);

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
