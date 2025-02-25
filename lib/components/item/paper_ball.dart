import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class PaperBall extends SpriteComponent
    with HasGameReference<WOTGame>, TapCallbacks {
  static final String imagePath = images.paperBall;
  static final String name = 'item_paper_ball';

  final void Function(TapDownEvent event)? onTapDownCallback;

  PaperBall({
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
    if (!game.images.containsKey(PaperBall.imagePath)) {
      await game.images.load(PaperBall.imagePath);
    }
    final image = game.images.fromCache(PaperBall.imagePath);
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
