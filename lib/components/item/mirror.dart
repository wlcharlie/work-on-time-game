import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class Mirror extends SpriteComponent
    with HasGameReference<WOTGame>, TapCallbacks {
  static final String imagePath = images.mirror;
  static final String name = 'item_mirror';

  final void Function(TapDownEvent event)? onTapDownCallback;

  Mirror({
    required Vector2 position,
    int priority = 0,
    this.onTapDownCallback,
  }) {
    this.position = position;
    this.priority = priority;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (!game.images.containsKey(Mirror.imagePath)) {
      await game.images.load(Mirror.imagePath);
    }
    final image = game.images.fromCache(Mirror.imagePath);
    sprite = Sprite(image);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (onTapDownCallback != null) {
      onTapDownCallback!(event);
    }
  }
}
