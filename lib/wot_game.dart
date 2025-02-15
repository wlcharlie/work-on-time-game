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
  }

  // - PanDetector
  // 看起來能只透過FlameGame extends PanDetector 來實現嗎
  void onPanDown(DragDownInfo info) {
    super.onPanDown(info);
  }

  @override
  void onPanStart(DragStartInfo info) {
    super.onPanStart(info);
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
