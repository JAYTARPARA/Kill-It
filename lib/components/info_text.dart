import 'package:KillIt/game_controller.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

class InfoText {
  final GameController gameController;
  TextPainter painter;
  Offset position;

  InfoText(this.gameController) {
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
      text: 'HOW TO PLAY \n \n Click on red enemy 3 times to kill them.\n Otherwise they kill you.',
      style: TextStyle(
        color: Colors.red,
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
      ),
    );

    painter.layout();

    position = Offset(
      (gameController.screenSize.width / 2) - painter.width / 2,
      (gameController.screenSize.height * 0.80) - painter.height / 2,
    );
  }
}
