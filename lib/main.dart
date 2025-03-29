import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_on_time_game/overlays/home_level_inspector.dart';
import 'package:work_on_time_game/overlays/inventory.dart';
import 'package:work_on_time_game/screen/loading.dart';
import 'package:work_on_time_game/wot_game.dart';

final GlobalKey<RiverpodAwareGameWidgetState<WOTGame>> gameWidgetKey =
    GlobalKey<RiverpodAwareGameWidgetState<WOTGame>>();
final gameInstance = WOTGame();
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: RiverpodAwareGameWidget<WOTGame>(
            key: gameWidgetKey,
            game: gameInstance,
            loadingBuilder: (_) => Loading(),
            overlayBuilderMap: {
              // 'loading': (_, game) => Loading(),
              'homeLevelInspector': (_, game) => HomeLevelInspector(game: game),
              'inventory': (_, game) => Inventory(game: game),
            },
          ),
        ),
      ),
    ),
  );
}
