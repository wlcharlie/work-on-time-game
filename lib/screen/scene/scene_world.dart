import 'dart:async';

import 'package:flame/components.dart';
import 'package:work_on_time_game/screen/scene/rain_scene.dart';
import 'package:work_on_time_game/wot_game.dart';

class SceneWorld extends World with HasGameReference<WOTGame> {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    add(RainScene());
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}
