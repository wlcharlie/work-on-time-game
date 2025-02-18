import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:work_on_time_game/scene/playground.dart';

class WOTGame extends FlameGame with PanDetector {
  late final RouterComponent router;

  @override
  bool debugMode = true;

  @override
  void onLoad() {
    world = Playground();
    // 固定解析度(?) 看起來不用出兩倍圖了Ａ＿Ａ
    camera = CameraComponent.withFixedResolution(
      width: 393,
      height: 852,
    );
  }

  // - PanDetector
  // 看起來能只透過FlameGame extends PanDetector 來實現嗎
  @override
  void onPanDown(DragDownInfo info) {
    super.onPanDown(info);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    if (world.key == ComponentKey.named("playground")) {
      (world as Playground).handlePanUpdate(info);
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    super.onPanEnd(info);
  }

  @override
  void onPanCancel() {
    super.onPanCancel();
  }
}
