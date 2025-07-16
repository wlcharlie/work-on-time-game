import 'dart:async';

import 'package:flame/components.dart';
import 'package:work_on_time_game/screen/event_scene/money_on_ground_scene.dart';
import 'package:work_on_time_game/screen/event_scene/mrt_scene.dart';
import 'package:work_on_time_game/screen/event_scene/rain_scene.dart';
import 'package:work_on_time_game/wot_game.dart';

class EventSceneWorld extends World with HasGameReference<WOTGame> {
  late final RainScene rainScene;
  late final MrtScene mrtScene;
  late final MoneyOnGroundScene moneyOnGroundScene;
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    rainScene = RainScene();
    mrtScene = MrtScene();
    moneyOnGroundScene = MoneyOnGroundScene();
  }

  @override
  void onMount() {
    super.onMount();
    add(moneyOnGroundScene);
    // add(rainScene);
    // add(mrtScene);
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}
