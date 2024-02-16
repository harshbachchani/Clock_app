import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MyClock extends StatefulWidget {
  const MyClock({super.key, required this.size});
  final double size;
  @override
  State<MyClock> createState() => _MyClockState();
}

class _MyClockState extends State<MyClock> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness current = Theme.of(context).brightness;
    Color textColor = current == Brightness.light ? Colors.black : Colors.white;
    Color backgroundColor =
        current != Brightness.light ? Colors.black : Colors.white;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(backgroundColor, textColor),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final Color primary;
  final Color secondary;
  const ClockPainter(this.primary, this.secondary);
  @override
  void paint(Canvas canvas, Size size) {
    var dateTime = DateTime.now();

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);
    var fillBrush = Paint()..color = primary;
    var outlineBrush = Paint()
      ..color = secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 35;
    var centerBrush = Paint()..color = secondary;

    var secondBrush = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 50
      ..strokeCap = StrokeCap.round;
    var minuteBrush = Paint()
      ..color = secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 40
      ..strokeCap = StrokeCap.round;
    var hourBrush = Paint()
      ..color = secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 30
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outlineBrush);
    var hourHandX = centerX +
        radius *
            0.35 *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerY +
        radius *
            0.35 *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourBrush);
    var minHandX =
        centerX + radius * 0.50 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY =
        centerY + radius * 0.50 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minuteBrush);
    var secHandX =
        centerX + radius * 0.55 * cos(dateTime.second * 6 * pi / 180);
    var secHandY =
        centerY + radius * 0.55 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secondBrush);
    canvas.drawCircle(center, 15, centerBrush);
    var dashBrush = Paint()
      ..color = secondary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    var outerRadius = radius;
    var innerRadius = radius * 0.87;
    for (int i = 0; i < 360; i += 30) {
      var x1 = centerX + outerRadius * cos(i * pi / 180);
      var y1 = centerY + outerRadius * sin(i * pi / 180);
      var x2 = centerX + innerRadius * cos(i * pi / 180);
      var y2 = centerY + innerRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
