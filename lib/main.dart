import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:work_on_time_game/overlays/home_level_inspector.dart';
import 'package:work_on_time_game/screen/loading.dart';
import 'package:work_on_time_game/wot_game.dart';

void main() {
  runApp(
    GameWidget<WOTGame>(
      game: WOTGame(),
      loadingBuilder: (_) => Loading(),
      overlayBuilderMap: {
        // 'loading': (_, game) => Loading(),
        'homeLevelInspector': (_, game) => HomeLevelInspector(game: game),
      },
    ),
  );
}
