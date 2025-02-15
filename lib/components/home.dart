import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:work_on_time_game/wot_game.dart';

Map<String, Vector2> itemPositions = {
  'clock': Vector2(140, 176),
  'pay': Vector2(1006, 633),
  'tv': Vector2(456, 460),
  'box': Vector2(59, 598),
};

class Home extends PositionComponent with HasGameReference<WOTGame> {
  late SpriteComponent background;
  List<String> items = [];

  Home.withItems(this.items);

  // 提供給camera的可視範圍，減去遊戲視窗（裝置）的寬度
  // 由於預設高度同遊戲視窗（裝置），所以可移動高度設為0
  Shape get bounds => Rectangle.fromLTWH(0, 0, size.x - game.size.x, 0);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final image = game.images.fromCache("room/bg.png");
    final sprite = Sprite(image);
    final scale = game.size.y / sprite.src.bottom;
    final width = sprite.src.width * scale;
    background = SpriteComponent(
      sprite: sprite,
      size: Vector2(width, game.size.y),
    );
    size = Vector2(width, game.size.y);
    add(background);

    if (items.isNotEmpty) {
      for (var item in items) {
        final image = game.images.fromCache("room/$item.png");
        final sprite = Sprite(image);
        final itemComponent = SpriteComponent(
          sprite: sprite,
          position: itemPositions[item]!,
        );
        add(itemComponent);
      }
    }
  }
}
