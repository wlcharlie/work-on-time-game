import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:work_on_time_game/screen/home/bed_room.dart';
// import 'package:work_on_time_game/screen/home/living_room.dart';
import 'package:work_on_time_game/wot_game.dart';

class HomeWorld extends World with HasGameReference<WOTGame> {
  @override
  ComponentKey get key => ComponentKey.named("home_world");

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await Flame.images.loadAll([
      // 像是客廳的地方
      'living_room/bg.png',
      'living_room/bill.png',
      'living_room/box.png',
      'living_room/calendar.png',
      'living_room/clock.png',
      'living_room/coat.png',
      'living_room/pic_frame.png',
      'living_room/scarf.png',
      'living_room/tv.png',
      'living_room/vase.png',
      // 睡覺的地方
      'bed_room/bag.png',
      'bed_room/bg.png',
      'bed_room/blanket_do.png',
      'bed_room/blanket_undo.png',
      'bed_room/books.png',
      'bed_room/hair_iron.png',
      'bed_room/mirror.png',
      'bed_room/painting.png',
      'bed_room/paper_ball.png',
      'bed_room/phone.png',
    ]);
    // final livingRoom = LivingRoom();
    // add(livingRoom);

    // game.camera.viewfinder.anchor = Anchor.topLeft;
    // game.camera.setBounds(livingRoom.bounds);

    final bedRoom = BedRoom();
    add(bedRoom);

    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.setBounds(bedRoom.bounds);
  }

  void handlePanUpdate(DragUpdateInfo info) {
    game.camera.moveBy(Vector2(-info.delta.global.x, 0));
  }
}
