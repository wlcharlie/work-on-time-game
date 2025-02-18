import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:work_on_time_game/models/vector_with_index.dart';
import 'package:work_on_time_game/wot_game.dart';

Map<String, VectorWithIndex> itemPositions = {
  'bill': VectorWithIndex(x: 1001, y: 594),
  'box': VectorWithIndex(x: 67, y: 541),
  'calendar': VectorWithIndex(x: 704, y: 548),
  'clock': VectorWithIndex(x: 161, y: 159),
  'coat': VectorWithIndex(x: 791, y: 283, index: 1),
  'picFrame': VectorWithIndex(x: 797, y: 542),
  'scarf': VectorWithIndex(x: 964, y: 327),
  'tv': VectorWithIndex(x: 356, y: 416),
  'vase': VectorWithIndex(x: 0, y: 416),
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
    final width = sprite.src.width;
    background = SpriteComponent(
      sprite: sprite,
    );
    size = Vector2(width, game.size.y);
    add(background);

    if (items.isNotEmpty) {
      for (var item in items) {
        final image = game.images.fromCache("room/$item.png");
        final sprite = Sprite(image);
        final itemComponent = SpriteComponent(
          sprite: sprite,
          position: itemPositions[item]!.vector2,
          priority: itemPositions[item]!.index,
        );
        add(itemComponent);
      }
    }
  }
}
