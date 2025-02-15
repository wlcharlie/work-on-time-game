import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:work_on_time_game/wot_game.dart';

void main() {
  runApp(
    GameWidget(
      game: WOTGame(),
    ),
  );
}
