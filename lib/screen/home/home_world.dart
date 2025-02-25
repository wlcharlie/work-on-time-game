import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:work_on_time_game/components/item/mirror.dart';
import 'package:work_on_time_game/screen/home/bed_room.dart';
import 'package:work_on_time_game/screen/home/living_room.dart';
import 'package:work_on_time_game/wot_game.dart';

class HomeWorld extends World with HasGameReference<WOTGame> {
  final initialScene = 'bed_room';
  final bedRoom = BedRoom();
  final livingRoom = LivingRoom();
  String currentScene = ''; // living_room, bed_room

  static ComponentKey componentKey = ComponentKey.named("home_world");

  @override
  ComponentKey get key => componentKey;

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
      Mirror.imagePath,
      'bed_room/painting.png',
      'bed_room/paper_ball.png',
      'bed_room/phone.png',
    ]);

    game.camera.viewfinder.anchor = Anchor.topLeft;
    switchScene(initialScene);

    game.overlays.add('homeLevelInspector');
  }

  void switchScene(String scene) async {
    // currentScene = scene;
    if (scene == currentScene) return;

    if (scene == 'living_room') {
      currentScene = 'living_room';
      if (game.findByKey(bedRoom.key) != null) {
        remove(bedRoom);
      }
      add(livingRoom);
      game.camera.setBounds(livingRoom.bounds);
    } else if (scene == 'bed_room') {
      currentScene = 'bed_room';
      if (game.findByKey(livingRoom.key) != null) {
        remove(livingRoom);
      }
      add(bedRoom);
    }

    game.camera.moveTo(Vector2(0, 0));
  }
}
