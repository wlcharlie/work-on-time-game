import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:work_on_time_game/config/space_item.dart';
import 'package:work_on_time_game/wot_game.dart';

List<String> itemKeys = [
  'bag',
  'blanket_do',
  'blanket_undo',
  'books',
  'hair_iron',
  'mirror',
  'painting',
  'paper_ball',
  'phone',
];

class BedRoom extends PositionComponent with HasGameReference<WOTGame> {
  @override
  ComponentKey get key => ComponentKey.named("bed_room");

  late SpriteComponent background;

  Map<String, Component> items = {};

  // LivingRoom.withItems(this.items);

  // 提供給camera的可視範圍，減去遊戲視窗（裝置）的寬度
  // 由於預設高度同遊戲視窗（裝置），所以可移動高度設為0
  Shape get bounds => Rectangle.fromLTWH(0, 0, size.x - game.size.x, 0);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final image = game.images.fromCache("bed_room/bg.png");
    final sprite = Sprite(image);
    final width = sprite.src.width;
    background = SpriteComponent(
      sprite: sprite,
    );
    size = Vector2(width, game.size.y);
    add(background);

    if (itemKeys.isNotEmpty) {
      for (var key in itemKeys) {
        if (key == 'blanket_do') {
          continue;
        }
        final image = game.images.fromCache("bed_room/$key.png");
        final sprite = Sprite(image);
        final itemComponent = TappableSpriteComponent(
          name: key,
          sprite: sprite,
          position: itemPositions[key]!.vector2,
          priority: itemPositions[key]!.index,
        );
        items[key] = itemComponent;
        add(itemComponent);
      }
    }
  }
}

// 比起loop或許遊戲的設計方式就是每一個單一處理吧...
class TappableSpriteComponent extends SpriteComponent
    with TapCallbacks, HasGameReference<WOTGame> {
  String name;

  TappableSpriteComponent({
    required this.name,
    required Sprite sprite,
    required Vector2 position,
    required int priority,
  }) : super(sprite: sprite, position: position, priority: priority);

  @override
  void onTapUp(TapUpEvent event) {
    print('${name} onTapUp, ${event.canvasPosition}');

    if (name == 'blanket_do') {
      final image = game.images.fromCache('bed_room/blanket_undo.png');
      final sprite = Sprite(image);
      this.sprite = sprite;
      name = 'blanket_undo';
    } else if (name == 'blanket_undo') {
      final image = game.images.fromCache('bed_room/blanket_do.png');
      final sprite = Sprite(image);
      this.sprite = sprite;
      name = 'blanket_do';
    }
  }
}
