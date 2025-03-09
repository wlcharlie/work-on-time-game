import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class Door extends SpriteComponent
    with HasGameReference<WOTGame>, TapCallbacks {
  static final List<String> imagePaths = [
    images.doorClose,
    images.doorOpen,
  ];
  static final String name = 'item_door';

  int _currentIndex = 0;

  final void Function(TapDownEvent event)? onTapDownCallback;

  Door({
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
    if (!game.images.containsKey(Door.imagePaths[0])) {
      await game.images.load(Door.imagePaths[0]);
    }
    if (!game.images.containsKey(Door.imagePaths[1])) {
      await game.images.load(Door.imagePaths[1]);
    }
    final image = game.images.fromCache(Door.imagePaths[_currentIndex]);
    sprite = Sprite(image);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _currentIndex = (_currentIndex + 1) % Door.imagePaths.length;
    final image = game.images.fromCache(Door.imagePaths[_currentIndex]);
    sprite = Sprite(image);
    if (onTapDownCallback != null) {
      onTapDownCallback!(event);
    }
  }
}
