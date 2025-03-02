import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class EnterWay extends Component with HasGameReference<WOTGame> {
  @override
  ComponentKey get key => ComponentKey.named("enter_way");

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final background = SpriteComponent(
      sprite: Sprite(game.images.fromCache(images.enterWay)),
    );
    add(background);

    final width = background.sprite?.src.width ?? 0;
    final size = Vector2(width, game.size.y);
    game.camera.setBounds(Rectangle.fromLTWH(0, 0, size.x - game.size.x, 0));
  }
}
