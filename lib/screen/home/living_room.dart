import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:work_on_time_game/config/space_item.dart';
import 'package:work_on_time_game/wot_game.dart';

class LivingRoom extends PositionComponent with HasGameReference<WOTGame> {
  @override
  ComponentKey get key => ComponentKey.named("living_room");

  late SpriteComponent background;
  List<String> items = [
    'bill',
    'box',
    'calendar',
    'clock',
    'coat',
    'pic_frame',
    'scarf',
    'tv',
    'vase',
  ];

  // LivingRoom.withItems(this.items);

  // 提供給camera的可視範圍，減去遊戲視窗（裝置）的寬度
  // 由於預設高度同遊戲視窗（裝置），所以可移動高度設為0
  Shape get bounds => Rectangle.fromLTWH(0, 0, size.x - game.size.x, 0);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final image = game.images.fromCache("living_room/bg.png");
    final sprite = Sprite(image);
    final width = sprite.src.width;
    background = SpriteComponent(
      sprite: sprite,
    );
    size = Vector2(width, game.size.y);

    add(background);

    if (items.isNotEmpty) {
      for (var item in items) {
        final image = game.images.fromCache("living_room/$item.png");
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
