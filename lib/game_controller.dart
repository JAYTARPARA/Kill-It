import 'dart:math';
import 'dart:ui';

import 'package:KillIt/components/enemy.dart';
import 'package:KillIt/components/health_bar.dart';
import 'package:KillIt/components/highscore_text.dart';
import 'package:KillIt/components/info_text.dart';
import 'package:KillIt/components/player.dart';
import 'package:KillIt/components/score_text.dart';
import 'package:KillIt/components/start_text.dart';
import 'package:KillIt/enemy_spawner.dart';
import 'package:KillIt/state.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameController extends Game {
  final SharedPreferences storage;
  Random rand;
  Size screenSize;
  double tileSize;
  Player player;
  EnemySpawner enemySpawner;
  List<Enemy> enemies;
  HealthBar healthBar;
  int score;
  ScoreText scoreText;
  State state;
  HighscoreText highscoreText;
  StartText startText;
  InfoText infoText;

  GameController(this.storage) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    state = State.menu;
    rand = Random();
    player = Player(this);
    enemies = List<Enemy>();
    enemySpawner = EnemySpawner(this);
    healthBar = HealthBar(this);
    score = 0;
    scoreText = ScoreText(this);
    highscoreText = HighscoreText(this);
    startText = StartText(this);
    infoText = InfoText(this);
  }

  void render(Canvas c) {
    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    // Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    // Paint backgroundPaint = Paint()..color = Color(0xFFFFE082);
    Paint backgroundPaint = Paint()..color = Color(0xFFAED581);
    c.drawRect(background, backgroundPaint);

    player.render(c);

    if (state == State.menu) {
      startText.render(c);
      highscoreText.render(c);
      infoText.render(c);
    } else if (state == State.playing) {
      enemies.forEach((Enemy enemy) => enemy.render(c));
      scoreText.render(c);
      healthBar.render(c);
    }
  }

  void update(double t) {
    if (state == State.menu) {
      startText.update(t);
      infoText.update(t);
      highscoreText.update(t);
    } else if (state == State.playing) {
      enemySpawner.update(t);
      enemies.forEach((Enemy enemy) => enemy.update(t));
      enemies.removeWhere((Enemy enemy) => enemy.isDead);
      player.update(t);
      scoreText.update(t);
      healthBar.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails d) {
    if (state == State.menu) {
      state = State.playing;
    } else if (state == State.playing) {
      enemies.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(d.globalPosition)) {
          enemy.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    double x, y;

    switch (rand.nextInt(4)) {
      case 0:
        // Top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
        // Right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
        // Bottom
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
        // Left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }

    enemies.add(Enemy(
      this,
      x,
      y,
    ));
  }
}
