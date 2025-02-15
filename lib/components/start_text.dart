import 'package:KillIt/game_controller.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

class StartText {
  final GameController gameController;
  TextPainter painter;
  Offset position;

  StartText(this.gameController) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    painter.text = TextSpan(
      text: 'Touch screen to start',
      style: TextStyle(
        color: Color(0xFF000000),
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );

    painter.layout();

    position = Offset(
      (gameController.screenSize.width / 2) - painter.width / 2,
      (gameController.screenSize.height * 0.65) - painter.height / 2,
    );
  }
}
