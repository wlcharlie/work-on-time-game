import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:work_on_time_game/screen/event_scene/money_on_ground_scene.dart';
import 'package:work_on_time_game/screen/event_scene/grandma_crossing_scene.dart';
import 'package:work_on_time_game/screen/event_scene/traffic_light_scene.dart';
import 'package:work_on_time_game/screen/event_scene/mrt_scene.dart';
import 'package:work_on_time_game/screen/event_scene/rain_scene.dart';
import 'package:work_on_time_game/wot_game.dart';

class EventSceneWorld extends World with HasGameReference<WOTGame> {
  late final RainScene rainScene;
  late final MrtScene mrtScene;
  late final MoneyOnGroundScene moneyOnGroundScene;
  late final GrandmaCrossingScene grandmaCrossingScene;
  late final TrafficLightScene trafficLightScene;
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    rainScene = RainScene();
    mrtScene = MrtScene();
    moneyOnGroundScene = MoneyOnGroundScene();
    grandmaCrossingScene = GrandmaCrossingScene();
    trafficLightScene = TrafficLightScene();
  }

  @override
  void onMount() {
    super.onMount();

    // 選擇要測試的場景 - 可以隨時更改
    // add(moneyOnGroundScene);        // 地上有錢事件
    // add(grandmaCrossingScene);      // 老奶奶過馬路事件
    // add(trafficLightScene);         // 紅綠燈倒數事件

    // 原有場景 - 不動
    // add(rainScene);
    // add(mrtScene);

    // random mount!
    final random = Random();
    final randomIndex = random.nextInt(5);
    final scene = [
      moneyOnGroundScene,
      grandmaCrossingScene,
      trafficLightScene,
      rainScene,
      mrtScene
    ][randomIndex];
    print('randomIndex: $randomIndex');
    add(scene);
  }
}
