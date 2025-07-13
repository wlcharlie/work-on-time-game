import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/components/tap_circle.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/screen/interaction_capture/caputre_world.dart';
import 'package:work_on_time_game/screen/level_home/home_world.dart';
import 'package:work_on_time_game/screen/lobby/lobby_world.dart';
import 'package:work_on_time_game/screen/event_scene/rain_scene.dart';
import 'package:work_on_time_game/screen/event_scene/scene_world.dart';
import 'package:work_on_time_game/screen/level_traffic/traffic_world.dart';

class WOTGame extends FlameGame
    with TapDetector, PanDetector, RiverpodGameMixin {
  late final RouterComponent router;

  bool isPannable = true; // for camera usage

  @override
  bool debugMode = const bool.fromEnvironment('DEBUG', defaultValue: false);

  @override
  void onLoad() async {
    await super.onLoad();
    await Flame.images.load(images.loading);

    // sleep 3 seconds for the loading screen development
    await Future.delayed(const Duration(seconds: 1));

    camera = CameraComponent.withFixedResolution(
      width: 786,
      height: 1704,
    );

    router = RouterComponent(
      routes: {
        // 大廳 初始畫面
        'lobby': WorldRoute(LobbyWorld.new),
        // 關卡 收集出門物品
        'level_home': WorldRoute(LevelHomeWorld.new, maintainState: false),
        // 關卡 交通場景
        'level_traffic': WorldRoute(LevelTrafficWorld.new),
        // 事件 場景管理入口
        'event_scene': WorldRoute(EventSceneWorld.new, maintainState: false),
        // 互動 相機
        'interaction_capture':
            WorldRoute(InteractionCaptureWorld.new, maintainState: false),
      },
      initialRoute: 'lobby',
    );
    add(router);

    overlays.add('helper');
  }

  // - PanDetector
  // 看起來能只透過FlameGame extends PanDetector 來實現嗎
  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    if (!isPannable) return;
    final currentRoute = router.currentRoute;
    if (currentRoute.name == 'level_home') {
      camera.moveBy(Vector2(-info.delta.global.x * 2, 0));
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    router.add(TapCircle(center: info.eventPosition.global));
  }
}
