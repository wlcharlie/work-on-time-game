import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class LobbyWorld extends World
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  LobbyWorld() : super();

  static ComponentKey componentKey = ComponentKey.named("lobby_world");

  @override
  ComponentKey get key => componentKey;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    game.camera.viewfinder.anchor = Anchor.topLeft;
    final image = await Flame.images.load(images.lobbyBackground);
    final background = Sprite(image);
    final backgroundComponent = SpriteComponent()..sprite = background;
    add(backgroundComponent);
    game.overlays.add('lobbyTools');
  }
}
