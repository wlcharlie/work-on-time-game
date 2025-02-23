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
      'room/bill.png',
      'room/box.png',
      'room/calendar.png',
      'room/clock.png',
      'room/coat.png',
      'room/picFrame.png',
      'room/scarf.png',
      'room/tv.png',
      'room/vase.png',
    ]);
    final home = Home.withItems([
      'bill',
      'box',
      'calendar',
      'clock',
      'coat',
      'picFrame',
      'scarf',
      'tv',
      'vase'
    ]);
    add(home);

    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.setBounds(home.bounds);
  }

  void handlePanUpdate(DragUpdateInfo info) {
    // 平行移動的場地
    game.camera.moveBy(Vector2(-info.delta.global.x, 0));
  }
}
