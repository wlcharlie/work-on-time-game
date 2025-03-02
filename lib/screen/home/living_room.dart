import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:work_on_time_game/components/item/item_component.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class LivingRoom extends Component with HasGameReference<WOTGame> {
  @override
  ComponentKey get key => ComponentKey.named("living_room");

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final background = SpriteComponent(
      sprite: Sprite(game.images.fromCache(images.livingRoomBackground)),
    );
    add(background);

    final width = background.sprite?.src.width ?? 0;
    final size = Vector2(width, game.size.y);
    // 提供給camera的可視範圍，減去遊戲視窗（裝置）的寬度
    // 由於預設高度同遊戲視窗（裝置），所以可移動高度設為0
    game.camera.setBounds(Rectangle.fromLTWH(0, 0, size.x - game.size.x, 0));
    print('background priority: ${background.priority}');

    add(ItemComponent(
      imagePath: images.vase,
      name: 'vase',
      position: Vector2(0, 416),
    ));
  }
}
