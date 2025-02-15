import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:work_on_time_game/components/home.dart';
import 'package:work_on_time_game/wot_game.dart';

class Playground extends World with HasGameReference<WOTGame> {
  @override
  ComponentKey get key => ComponentKey.named("playground");

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await Flame.images.loadAll([
      'room/bg.png',
      'room/box.png',
      'room/clock.png',
      'room/pay.png',
      'room/tv.png'
    ]);
    final home = Home.withItems(['box', 'clock', 'pay', 'tv']);
    add(home);

    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.setBounds(home.bounds);
  }

  void handlePanUpdate(DragUpdateInfo info) {
    // 平行移動的場地
    game.camera.moveBy(Vector2(-info.delta.global.x, 0));
  }
}
