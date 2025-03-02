import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:work_on_time_game/wot_game.dart';

class ItemComponent extends SpriteComponent
    with HasGameReference<WOTGame>, TapCallbacks {
  final String imagePath;
  final String name;
  ItemComponent({
    required this.imagePath,
    required this.name,
    required Vector2 position,
    int priority = 0,
  }) {
    this.position = position;
    this.priority = priority;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (!game.images.containsKey(imagePath)) {
      await game.images.load(imagePath);
    }
    final image = game.images.fromCache(imagePath);
    sprite = Sprite(image);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    print('you tap $name');
  }
}
