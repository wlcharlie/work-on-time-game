import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class TrafficPlayerComponent extends SpriteComponent
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  TrafficPlayerComponent() : super(size: Vector2(200, 200));

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = Sprite(game.images.fromCache(images.walk));
    position = Vector2(
      game.size.x / 2 - size.x / 2,
      game.size.y * 0.6 - 300,
    );
  }

  void moveTo(Vector2 target) {
    // TODO: 加入移動動畫
    position = target;
  }
}
