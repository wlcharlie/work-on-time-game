import 'dart:async';

import 'package:flame/components.dart';
import 'package:work_on_time_game/screen/scene/rain_scene.dart';
import 'package:work_on_time_game/wot_game.dart';

class SceneWorld extends World with HasGameReference<WOTGame> {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    // 設定相機的其他屬性
    game.camera.viewfinder.anchor = Anchor.topLeft;
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
