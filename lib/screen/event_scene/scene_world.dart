import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/providers/global.dart';
import 'package:work_on_time_game/screen/event_scene/money_on_ground_scene.dart';
import 'package:work_on_time_game/screen/event_scene/grandma_crossing_scene.dart';
import 'package:work_on_time_game/screen/event_scene/traffic_light_scene.dart';
import 'package:work_on_time_game/screen/event_scene/mrt_scene.dart';
import 'package:work_on_time_game/screen/event_scene/rain_scene.dart';
import 'package:work_on_time_game/wot_game.dart';

class EventSceneWorld extends World
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  late final RainScene rainScene;
  late final MrtScene mrtScene;
  late final MoneyOnGroundScene moneyOnGroundScene;
  late final GrandmaCrossingScene grandmaCrossingScene;
  late final TrafficLightScene trafficLightScene;

  late final Map<String, Component> scenes;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    rainScene = RainScene();
    mrtScene = MrtScene();
    moneyOnGroundScene = MoneyOnGroundScene();
    grandmaCrossingScene = GrandmaCrossingScene();
    trafficLightScene = TrafficLightScene();

    scenes = {
      'rain': rainScene,
      'mrt': mrtScene,
      'moneyOnGround': moneyOnGroundScene,
      'grandmaCrossing': grandmaCrossingScene,
      'trafficLight': trafficLightScene,
    };
  }

  @override
  void onMount() {
    super.onMount();

    final global = ref.read(globalNotifierProvider);
    if (global['currentEventScene'] != null) {
      add(scenes[global['currentEventScene']]!);
    }
  }
}
