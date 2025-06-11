import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_on_time_game/overlays/helper.dart';
import 'package:work_on_time_game/overlays/home_level_inspector.dart';
import 'package:work_on_time_game/overlays/inventory.dart';
import 'package:work_on_time_game/overlays/lobby_tools.dart';
import 'package:work_on_time_game/screen/loading.dart';
import 'package:work_on_time_game/screen/event_scene/rain_scene.dart';
import 'package:work_on_time_game/wot_game.dart';
import 'package:work_on_time_game/screen/level_traffic/traffic_screen.dart';

final GlobalKey<RiverpodAwareGameWidgetState<WOTGame>> gameWidgetKey =
    GlobalKey<RiverpodAwareGameWidgetState<WOTGame>>();
final gameInstance = WOTGame();
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Scaffold(
                body: RiverpodAwareGameWidget<WOTGame>(
                  key: gameWidgetKey,
                  game: gameInstance,
                  loadingBuilder: (_) => Loading(),
                  overlayBuilderMap: {
                    'lobbyTools': (_, game) => LobbyTools(game: game),
                    'homeLevelInspector': (_, game) =>
                        HomeLevelInspector(game: game),
                    'inventory': (_, game) => Inventory(game: game),
                    'helper': (_, game) => Helper(game: game),
                  },
                ),
              ),
          '/traffic': (context) => const TrafficScreen(),
        },
      ),
    ),
  );
}
