import 'dart:async';

import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:KillIt/game_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  SharedPreferences storage = await SharedPreferences.getInstance();

  GameController gameController = GameController(storage);
  runApp(gameController.widget);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = gameController.onTapDown;
  flameUtil.addGestureRecognizer(tapper);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _register() {
    _firebaseMessaging.getToken().then((token) => print(token));
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    });
  }

  Timer(new Duration(seconds: 1), () async {
    _register();
    getMessage();
  });
}
