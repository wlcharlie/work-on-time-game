import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_on_time_game/overlays/helper.dart';
import 'package:work_on_time_game/overlays/home_level_inspector.dart';
import 'package:work_on_time_game/overlays/inventory.dart';
import 'package:work_on_time_game/overlays/lobby_tools.dart';
import 'package:work_on_time_game/overlays/animal_collection.dart';
import 'package:work_on_time_game/screen/level_traffic/traffic_screen.dart';
import 'package:work_on_time_game/screen/loading.dart';
import 'package:work_on_time_game/wot_game.dart';

final GlobalKey<RiverpodAwareGameWidgetState<WOTGame>> gameWidgetKey =
    GlobalKey<RiverpodAwareGameWidgetState<WOTGame>>();
final gameInstance = WOTGame();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    const ProviderScope(
      child: WOTApp(),
    ),
  );
}

class WOTApp extends StatelessWidget {
  const WOTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => Scaffold(
              body: Stack(
                children: [
                  RiverpodAwareGameWidget<WOTGame>(
                    key: gameWidgetKey,
                    game: gameInstance,
                    loadingBuilder: (_) => Loading(),
                    overlayBuilderMap: {
                      'lobbyTools': (_, game) => LobbyTools(game: game),
                      'homeLevelInspector': (_, game) =>
                          HomeLevelInspector(game: game),
                      'inventory': (_, game) => Inventory(game: game),
                      'helper': (_, game) => Helper(game: game),
                      'animalCollection': (_, game) => AnimalCollectionOverlay(game: game),
                    },
                  ),
                ],
              ),
            ),
        '/traffic': (context) => const TrafficScreen(),
      },
    );
  }
}
