import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/components/tap_circle.dart';
import 'package:work_on_time_game/screen/home/home_world.dart';
import 'package:work_on_time_game/screen/lobby/lobby_world.dart';

class WOTGame extends FlameGame
    with TapDetector, PanDetector, RiverpodGameMixin {
  late final RouterComponent router;

  @override
  bool debugMode = true;

  @override
  void onLoad() async {
    await super.onLoad();
    // sleep 3 seconds for the loading screen development
    await Future.delayed(const Duration(seconds: 1));

    // 固定解析度(?) 看起來不用出兩倍圖了Ａ＿Ａ
    camera = CameraComponent.withFixedResolution(
      width: 393,
      height: 852,
    );

    router = RouterComponent(
      routes: {
        // 大廳 初始畫面
        'lobby': WorldRoute(LobbyWorld.new),
        // 關卡 收集出門物品
        'home': WorldRoute(HomeWorld.new),
      },
      initialRoute: 'lobby',
    );
    add(router);
  }

  // - PanDetector
  // 看起來能只透過FlameGame extends PanDetector 來實現嗎
  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    final currentRoute = router.currentRoute;
    if (currentRoute.name == 'home') {
      camera.moveBy(Vector2(-info.delta.global.x, 0));
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    print('onTapDown');
    super.onTapDown(info);
    router.add(TapCircle(center: info.eventPosition.global));
  }
}
