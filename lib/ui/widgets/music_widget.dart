import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_app/providers/app_provider.dart';

import '../../constants.dart';

class MusicWidget extends StatelessWidget {
  const MusicWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appPro, _) {
      return InkWell(
        onTap: () {
          appPro.muted = !appPro.muted;
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Image.asset(
                "assets/icons/itunes.png",
                height: 42,
                width: 42,
                fit: BoxFit.contain,
                color: secondaryColor,
              ),
              if (appPro.muted)
                CustomPaint(
                  size: Size(45, 45),
                  painter: DiagonalStrikeThroughPainter(),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class DiagonalStrikeThroughPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
