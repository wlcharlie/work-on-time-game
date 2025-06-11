import 'dart:async';

import 'package:flame/components.dart';
import 'package:work_on_time_game/screen/event_scene/rain_scene.dart';
import 'package:work_on_time_game/wot_game.dart';

class EventSceneWorld extends World with HasGameReference<WOTGame> {
  late final RainScene rainScene;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    rainScene = RainScene();
  }

  @override
  void onMount() {
    super.onMount();
    add(rainScene);
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}
