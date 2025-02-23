import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:work_on_time_game/screen/home/home_world.dart';

class WOTGame extends FlameGame with PanDetector {
  late final RouterComponent router;
  late final HomeWorld homeWorld;

  @override
  bool debugMode = true;

  @override
  void onLoad() {
    homeWorld = HomeWorld();

    world = homeWorld;
    // 固定解析度(?) 看起來不用出兩倍圖了Ａ＿Ａ
    camera = CameraComponent.withFixedResolution(
      width: 393,
      height: 852,
    );
  }

  // - PanDetector
  // 看起來能只透過FlameGame extends PanDetector 來實現嗎
  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    if (world.key == homeWorld.key) {
      (world as HomeWorld).handlePanUpdate(info);
    }
  }
}
