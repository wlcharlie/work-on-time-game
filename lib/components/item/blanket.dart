import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class Blanket extends SpriteComponent
    with HasGameReference<WOTGame>, TapCallbacks {
  static final List<String> imagePaths = [
    images.blanketDo,
    images.blanketUndo,
  ];
  static final String name = 'item_blanket';

  int _currentIndex = 0;

  final void Function(TapDownEvent event)? onTapDownCallback;

  Blanket({
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
    if (!game.images.containsKey(Blanket.imagePaths[0])) {
      await game.images.load(Blanket.imagePaths[0]);
    }
    if (!game.images.containsKey(Blanket.imagePaths[1])) {
      await game.images.load(Blanket.imagePaths[1]);
    }
    final image = game.images.fromCache(Blanket.imagePaths[_currentIndex]);
    sprite = Sprite(image);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _currentIndex = (_currentIndex + 1) % Blanket.imagePaths.length;
    final image = game.images.fromCache(Blanket.imagePaths[_currentIndex]);
    sprite = Sprite(image);
    if (onTapDownCallback != null) {
      onTapDownCallback!(event);
    }
  }
}
